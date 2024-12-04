import admin from 'firebase-admin';
import Notification from '../models/Notification';


export async function getStudentNotifcations(studentId: number) {
    const data = await Notification.findAll({
        where: {
            studentId: studentId
        }
    });
    return data;
}

export async function saveNotification(studentId, joinRequestId, notificationType) {
        const result = await Notification.create({
            studentId: studentId,
            joinRequestId: joinRequestId,
            notificationType: notificationType
        })
        return result;
}

const getNotificationTemplate = (notificationType: string) => {
    switch (notificationType) {
        case 'joinRequest':
            return {
            title: 'New Join Request',
            body: 'A student wants to join your group.',
            };

        case 'accept':
            return {
            title: 'Join Request Accepted',
            body: 'Your request to join the group has been accepted!',
            };

        case 'reject':
            return {
            title: 'Join Request Rejected',
            body: 'Your request to join the group has been rejected.',
            };

        default:
            return {
            title: 'Notification',
            body: 'You have a new notification.',
        };
    }
};

export const sendPushNotification = async ( studentId: number, joinRequestId: number, token: string, notificationType: string) => {
    try {
        const template = getNotificationTemplate(notificationType);
        if (!template) {
            throw new Error(`Invalid notification type: ${notificationType}`);
        }
        const message = {
            notification: template,
            token,
        };
        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);
        await saveNotification(studentId, joinRequestId, notificationType);
        } catch (error) {
        console.error('Failed to send push notification:', error.message);
        }
};

