import { Request } from 'express';
import { getStudentId } from '../middlewares/auth_middleware';
import { getStudentFirebaseToken } from '../service/firebase_token_service';
import { getCurrentMemberCount, joinGroup } from '../service/group_member';
import { getGroupById } from '../service/group_service';
import { createJoinRequest, getJoinRequestById, getPendingJoinRequestByGroupId, updateJoinRequestStatus } from '../service/join_request_service';
import { NotificationType, sendPushNotification } from '../service/notification_service';
import { getStudentById } from '../service/student_service';
import { getUnigeProfile } from '../service/unige_service';
import { NotFoundError, ValidationError } from '../utils/api_error';
import { checkBoolean, checkInt } from '../utils/validation_error';

export async function joinTheGroup(req: Request) {
    const studentId = getStudentId(req);
    const groupId = checkInt(req.body, "groupId");
    console.log(`studentId:${studentId}`);
    console.log(`groupId:${groupId}`);

    const student = await getStudentById(studentId);
    if (student === null) {
        console.log('Student not found');
        throw new NotFoundError('Student not found');
    }
    if (student.telegramAccount === undefined) {
        console.log('Student has not linked their Telegram account');
        throw new ValidationError('Student has not linked their Telegram account');
    }

    const group = await getGroupById(groupId);
    if (group === null) {
        console.log('Could not find group information');
        throw new NotFoundError('Group not found');
    }

    if (group.adminId == studentId) {
        throw new ValidationError('You are trying to join your group');
    }

    const joinRequest = await getPendingJoinRequestByGroupId(studentId, groupId);
    if (joinRequest != null) {
        console.log('Already sent join request');
        throw new ValidationError('You already sent join request');
    }

    const memberCount = await getCurrentMemberCount(groupId);
    const membersLimit = group.membersLimit;
    if (memberCount >= membersLimit) {
        throw new ValidationError('The group has reached its member limit.');
    }

    const isPublic = group.isPublic;
    if (isPublic) {
        await joinGroup(studentId, groupId);
        return { message: 'Student added to the group successfully' };
    } else {
        const joinRequest = await createJoinRequest(studentId, groupId);
        const joinRequestId = joinRequest.id;

        const adminId = group.adminId;

        const fbToken = await getStudentFirebaseToken(adminId);
        if (fbToken === null) {
            console.log('Firebase token not found for the student');
            // throw new ValidationError('Student has not registered a device for notifications.');
        } else {

            const student = await getUnigeProfile(studentId);

            const token = fbToken.token;
            await sendPushNotification(adminId, joinRequestId, token, NotificationType.JOIN_REQUEST, student.first_name + ' ' + student.last_name, group.name);
        }
        return { message: 'Join request submitted successfully' };
    }
};

export async function changeJoinRequestStatus(req: Request) {
    const adminId = getStudentId(req);
    const joinRequestId = checkInt(req.body, "joinRequestId");
    const isAccepted = checkBoolean(req.body, "isAccepted");

    console.log(joinRequestId)
    const joinRequest = await getJoinRequestById(joinRequestId)
    console.log(`---- ${joinRequest}`)
    if (joinRequest === null) {
        console.log('JoinRequest not found')
        throw new NotFoundError('JoinRequest not found')
    }

    if (joinRequest.status !== 'pending') {
        console.log('Admin student has already managed the join request');
        throw new ValidationError('You have already managed the request');
    }

    const groupId = joinRequest.groupId

    const group = await getGroupById(groupId)
    if (group === null) {
        console.log('Group not found')
        throw new NotFoundError('Group not found');
    }

    const fbToken = await getStudentFirebaseToken(joinRequest.studentId);

    const groupAdminId = group.adminId
    if (groupAdminId !== adminId)
        throw new ValidationError("You don't have permission");
    if (!isAccepted) {
        await updateJoinRequestStatus(joinRequestId, NotificationType.REJECT)
        if (fbToken === null)
            console.log('Could not find the firebase token of requested student');
        else
            await sendPushNotification(joinRequest.studentId, joinRequestId, fbToken.token, NotificationType.REJECT, '', group.name);
        return { message: 'Join request rejected successfully' };
    }
    const currentLimit = await getCurrentMemberCount(groupId);
    const membersLimit = group.membersLimit
    if (membersLimit < currentLimit + 1) {
        console.log('The group is already reached the limit of members')
        throw new ValidationError('The group is already reached the limit of members');
    }
    await updateJoinRequestStatus(joinRequestId, NotificationType.ACCEPT)
    if (fbToken === null)
        console.log('Could not find the firebase token of requested student');
    else
        await sendPushNotification(joinRequest.studentId, joinRequestId, fbToken.token, NotificationType.ACCEPT, '', group.name);
    return { message: 'Join request accepted successfully' };
}
