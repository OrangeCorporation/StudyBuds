import GroupMembers from "../models/GroupMembers";

export async function getCurrentMemberList(groupId) {
    const cnt = await GroupMembers.count({
        where: {
            group_id: groupId
        }
    });
    return cnt;
}

export async function joinGroup(studentId, groupId) {
    const joinGroup = await GroupMembers.create({
        student_id: studentId,
        group_id: groupId
    });
    return joinGroup;
}