import { Op } from "sequelize";
import assert from "assert";
import { StudentGroup } from "../models/StudentGroup";
import { GroupMembers } from "../models/GroupMembers";

interface JoinedGroupList {
  ownedGroups: Partial<StudentGroup>[];
  joinedGroups: Partial<StudentGroup>[];
}

async function getAllJoinedGroupList(
  studentId: number,
): Promise<Partial<StudentGroup>[]> {
  const result = await StudentGroup.findAll({
    attributes: ["id", "name", "description", "course", "isPublic", "adminId"],
    include: {
      model: GroupMembers,
      required: true,
      attributes: [],
      where: { studentId: { [Op.eq]: studentId } },
    },
  });
  return result;
}

function splitJoinedGroupList(
  input: Partial<StudentGroup>[],
  studentId: number,
): JoinedGroupList {
  const ownedGroups = input
    .filter((x) => x.adminId === studentId)
    .map((x) => {
      assert(x.toJSON !== undefined);
      x=x.toJSON();
      delete x.adminId;
      return x;
    });
  const joinedGroups = input
    .filter((x) => x.adminId !== studentId)
    .map((x) => {
      assert(x.toJSON !== undefined);
      x=x.toJSON();
      delete x.adminId;
      return x;
    });
  return {
    ownedGroups,
    joinedGroups,
  };
}

export async function getJoinedGroupList(
  studentId: number,
): Promise<JoinedGroupList> {
  return splitJoinedGroupList(
    await getAllJoinedGroupList(studentId),
    studentId,
  );
}
