import { NextFunction } from 'express';
import { getStudentFirebaseToken } from '../service/firebase_token_service';
import { getCurrentMemberList } from '../service/group_member';
import { joinGroup } from '../service/group_member';
import { getGroupById } from '../service/group_service';
import { createJoinRequest, getJoinRequestById, updateJoinRequestStatus,getAllJoinRequests } from '../service/join_request_service';
import { sendPushNotification } from '../service/notification_service';
import { getStudentById } from '../service/student_service';
import { NotFoundError } from '../utils/notfound_error';
import { ValidationError } from '../utils/validation_error';

export const joinTheGroup = async (req, res, next: NextFunction) => {
    try {
        const { studentId, groupId } = req.body;
        console.log(`Payload received: studentId = ${studentId}, groupId = ${groupId}`);

        if (!studentId || !groupId) {
            return next(new ValidationError('studentId and groupId are required.'));
        }

        const student = await getStudentById(studentId);
        if (!student) {
            console.log('Student not found');
            return next(new NotFoundError('Student not found'));
        }else{
            console.log('Student found');
        }

        if (!student.telegramAccount) {
            console.log('Student has not linked their Telegram account');
            return next(new ValidationError('Student has not linked their Telegram account'));
        }else{
            console.log('Student has linked their Telegram account');
        }

        const group = await getGroupById(groupId);
        if (!group) {
            console.log('Could not find group information');
            return next(new NotFoundError('Group not found'));
        }else{
            console.log('Group found');
        }

        const memberCount = await getCurrentMemberList(groupId);
        const membersLimit = group.get('membersLimit') as number;
        if (memberCount >= membersLimit) {
            return next(new ValidationError('The group has reached its member limit.'));
        }else{
            console.log('Group has not reached its member limit');
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

export const changeJoinRequestStatus = async (req, res, next: NextFunction) => {
    try {
        const { adminId, joinRequestId, isAccepted } = req.body;

        if (!joinRequestId || adminId === undefined || isAccepted === undefined) {
            return next(new ValidationError('Admin ID, Join Request ID, and status are required.'));
        }

        const joinRequest = await getJoinRequestById(joinRequestId);
        if (!joinRequest) {
            return next(new NotFoundError('Join request not found.'));
        }

        const groupId = joinRequest.get('groupId') as number;
        const studentId = joinRequest.get('studentId') as number;

        const group = await getGroupById(groupId);
        if (!group) {
            return next(new NotFoundError('Group not found.'));
        }

        const groupAdminId = group.get('adminId') as number;
        if (groupAdminId !== adminId) {
            return next(new ValidationError('You do not have permission to update this join request.'));
        }

        if (!isAccepted) {
            await updateJoinRequestStatus(joinRequestId, 'Rejected');
            const studentFbToken = await getStudentFirebaseToken(studentId);

            if (studentFbToken) {
                const token = studentFbToken.get('token') as string;
                await sendPushNotification(studentId, joinRequestId, token, 'rejectedRequest');
            }

            return res.status(200).json({ message: 'Join request rejected successfully.' });
        }

        const currentLimit = group.get('currentMembersCnt') as number;
        const membersLimit = group.get('membersLimit') as number;

        if (currentLimit + 1 > membersLimit) {
            return next(new ValidationError('The group has reached its member limit.'));
        }

        await updateJoinRequestStatus(joinRequestId, 'Accepted');
        await joinGroup(studentId, groupId);

        const studentFbToken = await getStudentFirebaseToken(studentId);
        if (studentFbToken) {
            const token = studentFbToken.get('token') as string;
            await sendPushNotification(studentId, joinRequestId, token, 'acceptedRequest');
        }

        return res.status(200).json({ message: 'Join request accepted successfully.' });
    } catch (err) {
        console.error('Error in changeJoinRequestStatus:', err);
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

export const getAllRequests = async (req, res, next: NextFunction) => {
    try {
        // Fetch all join requests
        const joinRequests = await getAllJoinRequests();

        if (!joinRequests || joinRequests.length === 0) {
            return next(new NotFoundError('No join requests found.'));
        }

        // Return the list of join requests
        return res.status(200).json(joinRequests);
    } catch (err) {
        console.error('Error fetching join requests:', err);
        return res.status(500).json({ message: 'Internal server error.' });
    }
};

