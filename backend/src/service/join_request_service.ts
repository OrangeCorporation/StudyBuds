import { JoinRequest } from "../models/JoinRequest";

export async function createJoinRequest(studentId: number, groupId: number) {
    const joinGroup = await JoinRequest.create({
        studentId: studentId,
        groupId: groupId,
        status: "pending"
    });
    return joinGroup;
}


export async function getJoinRequestById(joinRequestId: number) {
    console.log('Fetching join request with ID:', joinRequestId);
    const data = await JoinRequest.findOne({
        where: {
            id: joinRequestId,
        },
    });
    console.log('Join request data returned from DB:', data);
    return data;
}

export async function updateJoinRequestStatus(joinRequestId: number, status: string) {
    console.log('Updating join request with ID:', joinRequestId, 'to status:', status);
    return await JoinRequest.update(
        { status: status },
        {
            where: {
                id: joinRequestId,
            },
        }
    );
}


export async function getJoinRequestByGroupId(studentId: number, groupId: number) {
    console.log('Finding status of the group id:', groupId, "for student id:", studentId);
    const data = await JoinRequest.findOne({
        where: {
            studentId: studentId,
            groupId: groupId
        },
        attributes: ['status']  // Only return the status field
    });
    console.log('Join request data returned from DB:', data);
    return data;
}

export async function getPendingJoinRequestByGroupId(studentId: number, groupId: number) {
    console.log('Fetching pending join rewuest by groupId:', groupId);
    const data = await JoinRequest.findOne({
        where: {
            groupId: groupId,
            studentId: studentId,
            status: "pending"
        },
    });
    console.log('Join request data returned from DB:', data);
    return data;
}
