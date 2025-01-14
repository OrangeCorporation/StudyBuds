import assert from "assert";

interface JoinedGroupList {
  ownedGroups: Partial<StudentGroup>[];
  joinedGroups: Partial<StudentGroup>[];
}

import { literal, Op } from "sequelize";
import { GroupMembers } from "../models/GroupMembers";
import { StudentGroup } from "../models/StudentGroup";

async function getAllJoinedGroupList(
  studentId: number
): Promise<(Partial<StudentGroup> & { membersCount: number })[]> {
  const result = await StudentGroup.findAll({
    attributes: [
      "id",
      "name",
      "description",
      "course",
      "isPublic",
      "adminId",
      "telegramLink",
      [
        literal(`CAST((
          SELECT COUNT(*)
          FROM studybuds.group_members AS gm
          WHERE gm.group_id = "StudentGroup".id
        ) AS INTEGER)`),
        "membersCount",
      ],
    ],
    include: {
      model: GroupMembers,
      required: true,
      attributes: [],
      as: "groupMembers",
      where: { studentId: { [Op.eq]: studentId } },
    },
  });

  return result.map((group: any) => ({
    ...group.toJSON(),
    membersCount: group.getDataValue("membersCount"),
  }));
}

function splitJoinedGroupList(
  input: (Partial<StudentGroup> & { membersCount?: number })[],
  studentId: number
): JoinedGroupList {
  const ownedGroups = input
    .filter((x) => x.adminId === studentId)
    .map((x) => {
      assert(x.adminId !== undefined, "Expected adminId to be defined.");
      const group = { ...x };
      delete group.adminId;
      console.log(group);
      return group;
    });
  const joinedGroups = input
    .filter((x) => x.adminId !== studentId)
    .map((x) => {
      const group = { ...x };
      delete group.adminId;
      return group;
    });
  return {
    ownedGroups,
    joinedGroups,
  };
}

export async function getJoinedGroupList(
  studentId: number
): Promise<JoinedGroupList> {
  return splitJoinedGroupList(
    await getAllJoinedGroupList(studentId),
    studentId
  );
}
