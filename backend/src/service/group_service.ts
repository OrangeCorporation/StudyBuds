import { QueryTypes } from "sequelize";
import sequelize from "../config/database";
import { getErrorMessage } from "../utils/api_error";
import { StudentGroup, StudentGroupAttributes } from "../models/StudentGroup";


export async function getGroupById(groupId: number) {
  return await StudentGroup.findOne({
    where: {
      id: groupId,
    },
  });
}

export async function createGroup(groupData: StudentGroupAttributes): Promise<StudentGroup> {
  return await StudentGroup.create(groupData);
}

export async function basicSearch(text: string, studentId: number) {
  const searchText = `%${text}%`;
  console.log(text + " .. " + studentId);
  const query = `
            SELECT
                sg.id,
                sg.name,
                sg.description,
                sg.is_public,
                sg.course,
                COUNT(gm.student_id) AS member_count,
                jr.status
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
                jr.status
            ORDER BY
                member_count DESC;
        `;
  try {
    const results = await sequelize.query(query, {
      replacements: { searchText, studentId },
      type: QueryTypes.SELECT,
    });
    return results;
  } catch (error) {
    console.error(
      `Failed to execute basic search. Error: ${getErrorMessage(error)}`,
    );
    throw error;
  }
}

export default {
  createGroup,
  basicSearch,
};
