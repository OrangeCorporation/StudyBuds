import JoinRequest from "../models/JoinRequest";
import Student from "../models/Student";

export async function createJoinRequest(studentId, groupId) {
    const joinGroup = await JoinRequest.create({
        student_id: studentId,
        group_id: groupId,
        status: "Pending"
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

export async function updateJoinRequestStatus(joinRequestId, status) {
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

export const getAllJoinRequests = async () => {
    try {
        return await JoinRequest.findAll({
            attributes: ['student_id', 'group_id', 'status'],
        });

    } catch (error) {
        console.error('Error fetching join requests:', error);
        throw new Error('Failed to fetch join requests.');
    }
};
