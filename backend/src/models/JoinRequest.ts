import { DataTypes, Model, Optional } from 'sequelize';
import sequelize from '../config/database';

export interface JoinRequestAttributes {
    id: number;
    group_id: number;
    student_id: number;
    status: string;
    createdAt?: Date;
    updatedAt?: Date;
}

export interface JoinRequestCreationAttributes extends Optional<JoinRequestAttributes, 'id' | 'status' | 'createdAt' | 'updatedAt'> {}

class JoinRequest extends Model<JoinRequestAttributes, JoinRequestCreationAttributes> implements JoinRequestAttributes {
    public id!: number;
    public group_id!: number;
    public student_id!: number;
    public status!: string;
    public readonly createdAt!: Date;
    public readonly updatedAt!: Date;
}

JoinRequest.init(
    {
        id: {
            type: DataTypes.INTEGER,
            autoIncrement: true,
            primaryKey: true,
        },
        group_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            field: 'group_id',
            references: {
                model: 'student_group',
                key: 'id',
            },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE',
        },
        student_id: {
            type: DataTypes.INTEGER,
            allowNull: false,
            field: 'student_id',
            references: {
                model: 'Student',
                key: 'student_id',
            },
            onUpdate: 'CASCADE',
            onDelete: 'CASCADE',
        },
        status: {
            type: DataTypes.STRING,
            allowNull: false,
            defaultValue: 'Pending',
        },
        createdAt: {
            type: DataTypes.DATE,
            field: 'created_at',
            defaultValue: DataTypes.NOW,
        },
        updatedAt: {
            type: DataTypes.DATE,
            field: 'updated_at',
            defaultValue: DataTypes.NOW,
        },
    },
    {
        sequelize,
        tableName: 'join_request',
        schema: 'studybuds',
        timestamps: true,
        createdAt: 'created_at',
        updatedAt: 'updated_at',
    }
);

export default JoinRequest;
