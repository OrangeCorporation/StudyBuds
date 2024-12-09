import admin from 'firebase-admin';
import Notification, { NotificationType } from '../models/Notification';
import { getErrorMessage } from '../utils/api_error';

const NOTIFICATION_TEMPLATES:{[key in NotificationType]: {title:string,body:string}}={
    [NotificationType.JOIN_REQUEST]: {
                title: 'New Join Request',
                body: '{{studentName}} wants to join your group.',
            },
    [NotificationType.ACCEPT]: {
                title: 'Join Request Accepted',
                body: 'Your request to join the group {{groupName}} has been accepted!',
            },
    [NotificationType.REJECT]: {
                title: 'Join Request Rejected',
                body: 'Your request to join the group {{groupName}} has been rejected.',
            }
}

function getNotificationTemplate(notificationType: NotificationType, studentName: string, groupName: string) {
    const template = NOTIFICATION_TEMPLATES[notificationType];

    const title = template.title.replace('{{studentName}}', studentName).replace('{{groupName}}', groupName);
    const body = template.body.replace('{{studentName}}', studentName).replace('{{groupName}}', groupName);

    return { title, body };
}

export async function getStudentNotifications(studentId: number) {
    const data = await Notification.findAll({
        where: {
            studentId: studentId
        }
    });
    return data;
}

export async function saveNotification(studentId:number, joinRequestId:number, notificationType:string, message: string) {
    const result = await Notification.create({
        studentId: studentId,
        joinRequestId: joinRequestId,
        notificationType: notificationType,
        message: message
    })
    return result;
}

export async function sendPushNotification(studentId: number, joinRequestId: number, token: string, notificationType: NotificationType, studentName: string, groupName: string) {
    try {
        const template=getNotificationTemplate(notificationType, studentName, groupName);
        const message = {
            notification: template,
            token,
        };

        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);

        await saveNotification(studentId, joinRequestId, notificationType, template.body);
    } catch (error) {
        console.error('Failed to send push notification:', getErrorMessage(error));
        throw error;
    }
};

