import { DataTypes } from 'sequelize';
import sequelize from '../config/database';

const StudentGroup = sequelize.define(
    'StudentGroup', {
        id: {
            type: DataTypes.BIGINT,
            primaryKey: true,
        },
        name: {
            type: DataTypes.STRING,
            allowNull: false
        },
        description: {
            type: DataTypes.STRING,
        },
        membersLimit: {
            type: DataTypes.INTEGER,
            field: 'members_limit'
        },
        currentMembersCnt: {
            type: DataTypes.INTEGER,
            field: 'current_members_cnt'
        },
        isPublic: {
            type: DataTypes.BOOLEAN,
            field: 'is_public',
            defaultValue: false
        },
        course: {
            type: DataTypes.STRING,
            allowNull: false
        },
        telegramLink: {
            type: DataTypes.STRING,
            field: 'telegram_link'
        },
        telegramId: {
            type: DataTypes.INTEGER,
            field: 'telegram_id'
        },
        adminId: {
            type: DataTypes.INTEGER,
            allowNull: false,
            field: 'admin_id'
        },
    },
    {
        tableName: 'student_group',
        schema: 'studybuds',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at'
    }
);

export default StudentGroup;