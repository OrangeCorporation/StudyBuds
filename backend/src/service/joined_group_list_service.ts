import { Op } from "sequelize";
import Group from "../models/Group";
import GroupMembers from "../models/GroupMembers";

Group.hasMany(GroupMembers,{foreignKey: 'group_id'})
GroupMembers.hasOne(Group,{foreignKey: 'id'})

interface JoinedGroupList {
  ownedGroups: Group[];
  joinedGroups: Group[];
}

async function getAllJoinedGroupList(studentId: number): Promise<Group[]> {
  return await Group.findAll({
    include: {
      model: GroupMembers,
      required: true,
      where: { studentId: { [Op.eq]: studentId } },
    },
  });
}

function splitJoinedGroupList(
  input: Group[],
  studentId: number,
): JoinedGroupList {
  const ownedGroups = input.filter((x) => x.adminId === studentId);
  const joinedGroups = input.filter((x) => x.adminId !== studentId);
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
