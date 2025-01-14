import { QueryTypes } from "sequelize";
import sequelize from "../config/database";
import { StudentGroup } from "../models/StudentGroup";
import { getErrorMessage } from "../utils/api_error";
import { getCurrentMemberCount } from "./group_member";
import { getJoinRequestByGroupId } from "./join_request_service";
import { getSuggestedGroupsbyCourses, getSuggestedGroupsbyFriends, getSuggestedGroupsByGpa, getSuggestedGroupsbyPopularity } from "./suggestion_service";
import UnigeService from "./unige_service";

interface GroupData {
  name: string;
  description?: string;
  course: string;
  isPublic: boolean;
  membersLimit: number;
  telegramLink?: string;
  adminId: number; // Maps studentId to adminId
}

export async function getGroupById(groupId: number) {
  const data = await StudentGroup.findOne({
    where: {
      id: groupId,
    },
  });
  return data;
}

export async function createGroup(groupData: GroupData): Promise<StudentGroup> {
  const {
    name,
    description,
    course,
    isPublic,
    membersLimit,
    telegramLink,
    adminId,
  } = groupData;

  const student_info = await UnigeService.getUnigeProfile(adminId);
  const gpa = student_info.gpa || 0;
  const group = new StudentGroup({
    name,
    description,
    course,
    isPublic,
    gpa,
    membersLimit,
    telegramLink,
    adminId,
  });

  await group.save();
  return group;
}

interface SearchResult {
  id: number;
  name: string;
  description: string | null;
  isPublic: boolean;
  course: string;
  membersCount: number;
  requestStatus: string | null;
}

export interface PopularityResult {
  group_id: string;
  members: number
}

export async function basicSearch(
  text: string,
  studentId: number
): Promise<SearchResult[]> {
  const searchText = `%${text}%`;
  const query = `
    SELECT
      sg.id,
      sg.name,
      sg.description,
      sg.is_public AS "isPublic",
      sg.course,
      sg.telegram_link AS "telegramLink",
      CAST(COUNT(gm.student_id) AS INTEGER) AS "membersCount",
      jr.status AS "requestStatus",
      BOOL_OR(gm.student_id = :studentId) AS "hasJoined"
    FROM
      studybuds.student_group sg
    LEFT JOIN
      studybuds.group_members gm ON sg.id = gm.group_id
    LEFT JOIN
      studybuds.join_request jr ON sg.id = jr.group_id AND jr.student_id = :studentId
    WHERE
      sg.name ILIKE :searchText
      OR sg.description ILIKE :searchText
      OR sg.course ILIKE :searchText
    GROUP BY
      sg.id,
      sg.name,
      sg.description,
      sg.is_public,
      sg.course,
      sg.telegram_link,
      jr.status
    ORDER BY
      "membersCount" DESC;
  `;
  try {
    const results = await sequelize.query<SearchResult>(query, {
      replacements: { searchText, studentId },
      type: QueryTypes.SELECT,
    });
    results.forEach(element => {
      if (!element.hasJoined){
        delete element.telegramLink;
      }
      delete element.hasJoined;
    });
    return results;
  } catch (error) {
    console.error(`Failed to execute basic search. Error: ${getErrorMessage(error)}`);
    throw error;
  }
}




export async function getSuggestedGroups(
  studentId: number
): Promise<SearchResult[]> {

  // how many groups to return
  const HOW_MANY = 10;


  // weights for each suggestion method
  const POPULARITY_WEIGHT = 0.2;
  const FRIENDS_WEIGHT = 0.5;
  const GPA_WEIGHT = 0.3;

  const score: Map<number, number> = new Map();

  // Assign points to each group based on the order in the list
  const assignPoints = (group_list: StudentGroup[], weight: number) => {
    for (let i = 0; i < group_list.length; ++i) {
      let group_id = group_list[i]['id'];
      if (!score.has(group_id)) continue;
      let points = score.get(group_id) + weight * (group_list.length - i);
      score.set(group_id, points);
    }
  };

  // Get the suggested groups for each method
  const [courses, popularity, friends, gpa] = await Promise.all([
    getSuggestedGroupsbyCourses(studentId),
    getSuggestedGroupsbyPopularity(),
    getSuggestedGroupsbyFriends(studentId),
    getSuggestedGroupsByGpa()
  ]);

  // Initialize the score for each group to 0
  courses.forEach(group => score.set(group.id, 0));

  // Assign points to each group based on the order in the list
  assignPoints(popularity, POPULARITY_WEIGHT);
  assignPoints(friends, FRIENDS_WEIGHT);
  assignPoints(gpa, GPA_WEIGHT);

  // Sort the groups by score
  const ordered_scores = Array.from(score.entries()).sort((a, b) => b[1] - a[1]);

  // Return the top HOW_MANY groups
  const res: SearchResult[] = await Promise.all(
    ordered_scores.slice(0, HOW_MANY).map(async ([group_id]) => {
      const group = courses.find(group => group.id === group_id);
      if (!group) throw new Error(`Group with id ${group_id} not found`);

      const [memberCount, status] = await Promise.all([
        getCurrentMemberCount(group_id),
        getJoinRequestByGroupId(studentId, group_id)
      ]);

      return {
        id: group.id,
        name: group.name,
        description: group.description,
        isPublic: group.isPublic,
        course: group.course,
        membersCount: memberCount,
      };
    })
  );

  return res;
};




export default {
  createGroup,
  basicSearch,
  getSuggestedGroups,
};
