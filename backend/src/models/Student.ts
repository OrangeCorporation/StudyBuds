import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { FbToken, FbTokenId } from './FbToken';
import type { GroupMembers, GroupMembersId } from './GroupMembers';
import type { JoinRequest, JoinRequestId } from './JoinRequest';
import type { Notification, NotificationId } from './Notification';
import type { StudentGroup, StudentGroupId } from './StudentGroup';

export interface StudentAttributes {
  studentId: number;
  telegramAccount?: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export type StudentPk = "studentId";
export type StudentId = Student[StudentPk];
export type StudentOptionalAttributes = "telegramAccount" | "createdAt" | "updatedAt";
export type StudentCreationAttributes = Optional<StudentAttributes, StudentOptionalAttributes>;

export class Student extends Model<StudentAttributes, StudentCreationAttributes> implements StudentAttributes {
  studentId!: number;
  telegramAccount?: number;
  createdAt?: Date;
  updatedAt?: Date;

  // Student hasMany FbToken via studentId
  fbTokens!: FbToken[];
  getFbTokens!: Sequelize.HasManyGetAssociationsMixin<FbToken>;
  setFbTokens!: Sequelize.HasManySetAssociationsMixin<FbToken, FbTokenId>;
  addFbToken!: Sequelize.HasManyAddAssociationMixin<FbToken, FbTokenId>;
  addFbTokens!: Sequelize.HasManyAddAssociationsMixin<FbToken, FbTokenId>;
  createFbToken!: Sequelize.HasManyCreateAssociationMixin<FbToken>;
  removeFbToken!: Sequelize.HasManyRemoveAssociationMixin<FbToken, FbTokenId>;
  removeFbTokens!: Sequelize.HasManyRemoveAssociationsMixin<FbToken, FbTokenId>;
  hasFbToken!: Sequelize.HasManyHasAssociationMixin<FbToken, FbTokenId>;
  hasFbTokens!: Sequelize.HasManyHasAssociationsMixin<FbToken, FbTokenId>;
  countFbTokens!: Sequelize.HasManyCountAssociationsMixin;
  // Student hasMany GroupMembers via studentId
  groupMembers!: GroupMembers[];
  getGroupMembers!: Sequelize.HasManyGetAssociationsMixin<GroupMembers>;
  setGroupMembers!: Sequelize.HasManySetAssociationsMixin<GroupMembers, GroupMembersId>;
  addGroupMember!: Sequelize.HasManyAddAssociationMixin<GroupMembers, GroupMembersId>;
  addGroupMembers!: Sequelize.HasManyAddAssociationsMixin<GroupMembers, GroupMembersId>;
  createGroupMember!: Sequelize.HasManyCreateAssociationMixin<GroupMembers>;
  removeGroupMember!: Sequelize.HasManyRemoveAssociationMixin<GroupMembers, GroupMembersId>;
  removeGroupMembers!: Sequelize.HasManyRemoveAssociationsMixin<GroupMembers, GroupMembersId>;
  hasGroupMember!: Sequelize.HasManyHasAssociationMixin<GroupMembers, GroupMembersId>;
  hasGroupMembers!: Sequelize.HasManyHasAssociationsMixin<GroupMembers, GroupMembersId>;
  countGroupMembers!: Sequelize.HasManyCountAssociationsMixin;
  // Student hasMany JoinRequest via studentId
  joinRequests!: JoinRequest[];
  getJoinRequests!: Sequelize.HasManyGetAssociationsMixin<JoinRequest>;
  setJoinRequests!: Sequelize.HasManySetAssociationsMixin<JoinRequest, JoinRequestId>;
  addJoinRequest!: Sequelize.HasManyAddAssociationMixin<JoinRequest, JoinRequestId>;
  addJoinRequests!: Sequelize.HasManyAddAssociationsMixin<JoinRequest, JoinRequestId>;
  createJoinRequest!: Sequelize.HasManyCreateAssociationMixin<JoinRequest>;
  removeJoinRequest!: Sequelize.HasManyRemoveAssociationMixin<JoinRequest, JoinRequestId>;
  removeJoinRequests!: Sequelize.HasManyRemoveAssociationsMixin<JoinRequest, JoinRequestId>;
  hasJoinRequest!: Sequelize.HasManyHasAssociationMixin<JoinRequest, JoinRequestId>;
  hasJoinRequests!: Sequelize.HasManyHasAssociationsMixin<JoinRequest, JoinRequestId>;
  countJoinRequests!: Sequelize.HasManyCountAssociationsMixin;
  // Student hasMany Notification via studentId
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
  // Student belongsToMany StudentGroup via studentId and groupId
  groupIdStudentGroups!: StudentGroup[];
  getGroupIdStudentGroups!: Sequelize.BelongsToManyGetAssociationsMixin<StudentGroup>;
  setGroupIdStudentGroups!: Sequelize.BelongsToManySetAssociationsMixin<StudentGroup, StudentGroupId>;
  addGroupIdStudentGroup!: Sequelize.BelongsToManyAddAssociationMixin<StudentGroup, StudentGroupId>;
  addGroupIdStudentGroups!: Sequelize.BelongsToManyAddAssociationsMixin<StudentGroup, StudentGroupId>;
  createGroupIdStudentGroup!: Sequelize.BelongsToManyCreateAssociationMixin<StudentGroup>;
  removeGroupIdStudentGroup!: Sequelize.BelongsToManyRemoveAssociationMixin<StudentGroup, StudentGroupId>;
  removeGroupIdStudentGroups!: Sequelize.BelongsToManyRemoveAssociationsMixin<StudentGroup, StudentGroupId>;
  hasGroupIdStudentGroup!: Sequelize.BelongsToManyHasAssociationMixin<StudentGroup, StudentGroupId>;
  hasGroupIdStudentGroups!: Sequelize.BelongsToManyHasAssociationsMixin<StudentGroup, StudentGroupId>;
  countGroupIdStudentGroups!: Sequelize.BelongsToManyCountAssociationsMixin;
  // Student hasMany StudentGroup via adminId
  studentGroups!: StudentGroup[];
  getStudentGroups!: Sequelize.HasManyGetAssociationsMixin<StudentGroup>;
  setStudentGroups!: Sequelize.HasManySetAssociationsMixin<StudentGroup, StudentGroupId>;
  addStudentGroup!: Sequelize.HasManyAddAssociationMixin<StudentGroup, StudentGroupId>;
  addStudentGroups!: Sequelize.HasManyAddAssociationsMixin<StudentGroup, StudentGroupId>;
  createStudentGroup!: Sequelize.HasManyCreateAssociationMixin<StudentGroup>;
  removeStudentGroup!: Sequelize.HasManyRemoveAssociationMixin<StudentGroup, StudentGroupId>;
  removeStudentGroups!: Sequelize.HasManyRemoveAssociationsMixin<StudentGroup, StudentGroupId>;
  hasStudentGroup!: Sequelize.HasManyHasAssociationMixin<StudentGroup, StudentGroupId>;
  hasStudentGroups!: Sequelize.HasManyHasAssociationsMixin<StudentGroup, StudentGroupId>;
  countStudentGroups!: Sequelize.HasManyCountAssociationsMixin;

  static initModel(sequelize: Sequelize.Sequelize): typeof Student {
    return Student.init({
    studentId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      field: 'student_id'
    },
    telegramAccount: {
      type: DataTypes.INTEGER,
      allowNull: true,
      field: 'telegram_account'
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
    tableName: 'student',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "student_pkey",
        unique: true,
        fields: [
          { name: "student_id" },
        ]
      },
    ]
  });
  }
}
