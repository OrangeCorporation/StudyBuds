import { GroupMembers } from "../models/GroupMembers";
import { StudentGroup } from "../models/StudentGroup";
import { calculateAverageGpa } from "./unige_service";

export async function getCurrentMemberCount(groupId: number) {
    const cnt = await GroupMembers.count({
        where: {
            groupId: groupId
        }
    });
    return cnt;
}

export async function getCurrentMemberList(groupId: number) {
    const cnt = await GroupMembers.findAll({
        where: {
            groupId: groupId
        }
    });
    return cnt.map(member => member.studentId);
}




export async function joinGroup(studentId: number, groupId: number) {
    // old version
    // const num_old = await getCurrentMemberCount(groupId);

    // const student_info = await UnigeService.getUnigeProfile(studentId);
    // const gpa_s = student_info.gpa;

    // const group = await Group.findOne({
    //     where: {
    //         id: groupId
    //     }
    // });

    // const gpa_g = group.gpa;

    // // const gpa_new = (gpa_g * num_old + gpa_s) / (num_old + 1);

    const student_ids = await getCurrentMemberList(groupId);
    student_ids.push(studentId);
    const gpa_new = await calculateAverageGpa(student_ids);
    const gpa = gpa_new.average_gpa;
    await StudentGroup.update({
        gpa: gpa
    }, {
        where: {
            id: groupId
        }
    });


    const joinGroup = await GroupMembers.create({
        studentId: studentId,
        groupId: groupId
    });

    return joinGroup;
}
