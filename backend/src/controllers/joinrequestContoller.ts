import { NextFunction } from 'express';
import { getCurrentMemberList, joinGroup } from '../service/group_member';
import { getGroupById } from '../service/group_service';
import { createJoinRequest } from '../service/join_request_service';
import { getStudentById } from '../service/student_service';
import { NotFoundError } from '../utils/notfound_error';
import { ValidationError } from '../utils/validation_error';

export const joinTheGroup = async (req, res,  next: NextFunction) => {
    try {
        const { studentId, groupId } = req.body;
        console.log(`studentId:${studentId}`)
        if (!studentId || !groupId) {
            return next(new ValidationError('studentId and groupId are required.'));
        }
        
        const student = await getStudentById(studentId)
        if (!student) {
            console.log('student not found')
            return next(new NotFoundError('Student not found'))
        }
        if (!student.telegramAccount) {
            console.log('Student has not linked their Telegram account')
            return next(new ValidationError('Student has not linked their Telegram account'))
        }
        const group = await getGroupById(groupId)
        if (!group) {
            console.log('Could not find group information')
            return next(new NotFoundError('Group not found'))
        }
        const memberCount = await getCurrentMemberList(groupId)

        const membersLimit = group.get('membersLimit') as number;
        if (memberCount >= membersLimit) {
            return next(new ValidationError('The group has reached its member limit.'))
        }


        const isPublic = group.get('isPublic') as boolean;
        if (isPublic) {
            const groupMember = await joinGroup(studentId, groupId)
            return res.status(200).send('Student added to the group successfully')
        } else {
            const joinRequest = await createJoinRequest(studentId, groupId)
        // sendNotification(group.adminId)
            return res.status(200).send('Join request submitted successfully')
        }
    } catch (err) {
        console.error(err);
        res.status(500).send('Internal server error.');
    }
};
