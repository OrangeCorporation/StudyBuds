import { NextFunction } from 'express';
import { getStudentFirebaseToken } from '../service/firebase_token_service';
import { getCurrentMemberList, joinGroup } from '../service/group_member';
import { getGroupById } from '../service/group_service';
import { createJoinRequest, getJoinRequestById, updateJoinRequestStatus } from '../service/join_request_service';
import { sendPushNotification } from '../service/notification_service';
import { getStudentById } from '../service/student_service';
import { NotFoundError } from '../utils/notfound_error';
import { ValidationError } from '../utils/validation_error';

export const changeJoinRequestStatus = async (req, res, next: NextFunction) => {
    try {
        const { adminId, joinRequestId, isAccepted }  = req.body;
        console.log(joinRequestId)
        const joinRequest = await getJoinRequestById(joinRequestId)
        console.log(`---- ${joinRequest}`)
        if (!joinRequest) {
            console.log('JoinRequest not found')
            return next(new NotFoundError('JoinRequest not found'))
        }
        const groupId = joinRequest.get('groupId') as number
        const studentId = joinRequest.get('studentId') as number
        console.log(`groupId: ${groupId}`)
        const group = await getGroupById(groupId)
        if (!group) {
            console.log('Group not found')
            return next(new NotFoundError('Group not found'))
        }
        const groupAdminId = group?.get('adminId') as number
        if (groupAdminId != adminId)
            return next(new ValidationError("You don't have permission"))
        if (!isAccepted) {
            await updateJoinRequestStatus(joinRequestId, 'Rejected')
            // todo send notification
            return res.status(200).send('Join request rejected successfully');
        }
        const currentLimit = group.get('currentMembersCnt') as number
        const membersLimit = group.get('membersLimit') as number
        if (membersLimit < currentLimit + 1) {
            console.log('The group is already reached the limit of members')
            return next(new ValidationError('The group is already reached the limit of members'))
        }
        await updateJoinRequestStatus(joinRequestId, 'Accepted')
        // todo send notification
        return res.status(200).send('Join request accepted successfully');
    } catch (err) {
        console.error('Error in change join request status:', err);
        return res.status(500).send('Internal server error.');
    }
}

export const joinTheGroup = async (req, res, next: NextFunction) => {
    try {
        const { studentId, groupId } = req.body;
        console.log(`studentId:${studentId}`);
        if (!studentId || !groupId) {
            return next(new ValidationError('studentId and groupId are required.'));
        }

        const student = await getStudentById(studentId);
        if (!student) {
            console.log('Student not found');
            return next(new NotFoundError('Student not found'));
        }
        if (!student.telegramAccount) {
            console.log('Student has not linked their Telegram account');
            return next(new ValidationError('Student has not linked their Telegram account'));
        }

        const group = await getGroupById(groupId);
        if (!group) {
            console.log('Could not find group information');
            return next(new NotFoundError('Group not found'));
        }

        const memberCount = await getCurrentMemberList(groupId);
        const membersLimit = group.get('membersLimit') as number;
        if (memberCount >= membersLimit) {
            return next(new ValidationError('The group has reached its member limit.'));
        }

        const isPublic = group.get('isPublic') as boolean;
        if (isPublic) {
            await joinGroup(studentId, groupId);
            return res.status(200).send('Student added to the group successfully');
        } else {
            const joinRequest = await createJoinRequest(studentId, groupId);
            const joinRequestId = joinRequest.get('id') as number;

            const adminId = group.get('adminId') as number;

            const fbToken = await getStudentFirebaseToken(adminId);
            if (!fbToken) {
                console.log('Firebase token not found for the student');
                return next(new ValidationError('Student has not registered a device for notifications.'));
            }

            const token = fbToken.get('token') as string;
            await sendPushNotification(adminId, joinRequestId, token, 'joinRequest');

            return res.status(200).send('Join request submitted successfully');
        }
    } catch (err) {
        console.error('Error in joinTheGroup:', err);
        return res.status(500).send('Internal server error.');
    }
};
