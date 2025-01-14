import admin from 'firebase-admin';
import { camelCase } from 'lodash';
import { QueryTypes } from "sequelize";
import sequelize from "../config/database";
import { getErrorMessage } from '../utils/api_error';
import { Notification } from '../models/Notification';

export enum NotificationType{
    JOIN_REQUEST="join_request",
    ACCEPT="accept",
    REJECT="reject",
}


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

interface NotificationResult {
    id: number;
    studentId: number;
    joinRequestId: number;
    notificationType: string;
    message: string;
    createdAt: Date;
    joinRequestStatus: string;
}

export async function getStudentNotifications(studentId: number): Promise<NotificationResult[]> {
    const query = `
    SELECT
        n.id AS id,
        n.student_id AS "studentId",
        n.join_request_id AS "joinRequestId",
        n.notification_type AS "notificationType",
        n.message AS "message",
        n.created_at AS "createdAt",
        jr.status AS "joinRequestStatus"
    FROM
        studybuds.notification n
    INNER JOIN
        studybuds.join_request jr
    ON
        n.join_request_id = jr.id
    WHERE
        n.student_id = :studentId
    `;

    const results = await sequelize.query<any>(query, {
        replacements: { studentId },
        type: QueryTypes.SELECT,
    });

    return results.map((row) => {
        return Object.fromEntries(
            Object.entries(row).map(([key, value]) => [camelCase(key), value])
        ) as NotificationResult;
    });
}

export async function saveNotification(studentId:number, joinRequestId:number, notificationType:NotificationType, message: string) {
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
        // throw error;
    }
};

export async function testNotification(token:string, msg:string) {

    const message = {
            notification: {title: 'test', body: msg},
            token,
        };

        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);

}

