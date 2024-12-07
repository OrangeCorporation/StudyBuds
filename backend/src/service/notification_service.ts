import admin from 'firebase-admin';
import Notification, { NotificationType } from '../models/Notification';
import { getErrorMessage } from '../utils/api_error';

const NOTIFICATION_TEMPLATES:{[key in NotificationType]: {title:string,body:string}}={
    [NotificationType.JOIN_REQUEST]: {
                title: 'New Join Request',
                body: 'A student wants to join your group.',
            },
    [NotificationType.ACCEPT]: {
                title: 'Join Request Accepted',
                body: 'Your request to join the group has been accepted!',
            },
    [NotificationType.REJECT]: {
                title: 'Join Request Rejected',
                body: 'Your request to join the group has been rejected.',
            }
}

export async function getStudentNotifications(studentId: number) {
    const data = await Notification.findAll({
        where: {
            studentId: studentId
        }
    });
    return data;
}

export async function saveNotification(studentId:number, joinRequestId:number, notificationType:string) {
    const result = await Notification.create({
        studentId: studentId,
        joinRequestId: joinRequestId,
        notificationType: notificationType
    })
    return result;
}

export async function sendPushNotification(studentId: number, joinRequestId: number, token: string, notificationType: NotificationType) {
    try {
        const template=NOTIFICATION_TEMPLATES[notificationType];
        const message = {
            notification: template,
            token,
        };

        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);

        await saveNotification(studentId, joinRequestId, notificationType);
    } catch (error) {
        console.error('Failed to send push notification:', getErrorMessage(error));
        throw error;
    }
};

