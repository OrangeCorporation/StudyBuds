import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { Notification, NotificationId } from './Notification';
import type { Student, StudentId } from './Student';
import type { StudentGroup, StudentGroupId } from './StudentGroup';

export interface JoinRequestAttributes {
  id: number;
  groupId: number;
  studentId: number;
  status?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export type JoinRequestPk = "id";
export type JoinRequestId = JoinRequest[JoinRequestPk];
export type JoinRequestOptionalAttributes = "id" | "status" | "createdAt" | "updatedAt";
export type JoinRequestCreationAttributes = Optional<JoinRequestAttributes, JoinRequestOptionalAttributes>;

export class JoinRequest extends Model<JoinRequestAttributes, JoinRequestCreationAttributes> implements JoinRequestAttributes {
  id!: number;
  groupId!: number;
  studentId!: number;
  status?: string;
  createdAt?: Date;
  updatedAt?: Date;

  // JoinRequest hasMany Notification via joinRequestId
  notifications!: Notification[];
  getNotifications!: Sequelize.HasManyGetAssociationsMixin<Notification>;
  setNotifications!: Sequelize.HasManySetAssociationsMixin<Notification, NotificationId>;
  addNotification!: Sequelize.HasManyAddAssociationMixin<Notification, NotificationId>;
  addNotifications!: Sequelize.HasManyAddAssociationsMixin<Notification, NotificationId>;
  createNotification!: Sequelize.HasManyCreateAssociationMixin<Notification>;
  removeNotification!: Sequelize.HasManyRemoveAssociationMixin<Notification, NotificationId>;
  removeNotifications!: Sequelize.HasManyRemoveAssociationsMixin<Notification, NotificationId>;
  hasNotification!: Sequelize.HasManyHasAssociationMixin<Notification, NotificationId>;
  hasNotifications!: Sequelize.HasManyHasAssociationsMixin<Notification, NotificationId>;
  countNotifications!: Sequelize.HasManyCountAssociationsMixin;
  // JoinRequest belongsTo Student via studentId
  student!: Student;
  getStudent!: Sequelize.BelongsToGetAssociationMixin<Student>;
  setStudent!: Sequelize.BelongsToSetAssociationMixin<Student, StudentId>;
  createStudent!: Sequelize.BelongsToCreateAssociationMixin<Student>;
  // JoinRequest belongsTo StudentGroup via groupId
  group!: StudentGroup;
  getGroup!: Sequelize.BelongsToGetAssociationMixin<StudentGroup>;
  setGroup!: Sequelize.BelongsToSetAssociationMixin<StudentGroup, StudentGroupId>;
  createGroup!: Sequelize.BelongsToCreateAssociationMixin<StudentGroup>;

  static initModel(sequelize: Sequelize.Sequelize): typeof JoinRequest {
    return JoinRequest.init({
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    groupId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'student_group',
        key: 'id'
      },
      field: 'group_id'
    },
    studentId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'student',
        key: 'student_id'
      },
      field: 'student_id'
    },
    status: {
      type: DataTypes.STRING(20),
      allowNull: true
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: Sequelize.Sequelize.literal('CURRENT_TIMESTAMP'),
      field: 'created_at'
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: Sequelize.Sequelize.literal('CURRENT_TIMESTAMP'),
      field: 'updated_at'
    }
  }, {
    sequelize,
    tableName: 'join_request',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "join_request_pkey",
        unique: true,
        fields: [
          { name: "id" },
        ]
      },
    ]
  });
  }
}
