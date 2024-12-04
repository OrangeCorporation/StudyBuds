import { DataTypes } from 'sequelize';
import sequelize from '../config/database';

const Notification = sequelize.define(
    'Notification',
    {
        id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
        },
        studentId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            field: 'student_id',
        },
        joinRequestId: {
            type: DataTypes.BIGINT,
            allowNull: false,
            field: 'join_request_id',
        },
        notificationType: {
            type: DataTypes.STRING(20),
            allowNull: false,
            field: 'notification_type',
        },
        message: {
            type:DataTypes.STRING,
            allowNull: false,
            field: 'message'
        }
    },
    {
        tableName: 'notification',
        schema: 'studybuds',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at',
    }
);

export default Notification;
