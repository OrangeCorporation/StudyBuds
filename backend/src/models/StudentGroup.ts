import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { GroupMembers, GroupMembersId } from './GroupMembers';
import type { JoinRequest, JoinRequestId } from './JoinRequest';
import type { Student, StudentId } from './Student';

export interface StudentGroupAttributes {
  id: number;
  name: string;
  description?: string;
  membersLimit?: number;
  isPublic?: boolean;
  gpa: number;
  course: string;
  telegramLink?: string;
  telegramId?: number;
  adminId: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export type StudentGroupPk = "id";
export type StudentGroupId = StudentGroup[StudentGroupPk];
export type StudentGroupOptionalAttributes = "id" | "description" | "membersLimit" | "isPublic" | "telegramLink" | "telegramId" | "createdAt" | "updatedAt";
export type StudentGroupCreationAttributes = Optional<StudentGroupAttributes, StudentGroupOptionalAttributes>;

export class StudentGroup extends Model<StudentGroupAttributes, StudentGroupCreationAttributes> implements StudentGroupAttributes {
  id!: number;
  name!: string;
  description?: string;
  membersLimit?: number;
  isPublic?: boolean;
  gpa!: number;
  course!: string;
  telegramLink?: string;
  telegramId?: number;
  adminId!: number;
  createdAt?: Date;
  updatedAt?: Date;

  // StudentGroup belongsTo Student via adminId
  admin!: Student;
  getAdmin!: Sequelize.BelongsToGetAssociationMixin<Student>;
  setAdmin!: Sequelize.BelongsToSetAssociationMixin<Student, StudentId>;
  createAdmin!: Sequelize.BelongsToCreateAssociationMixin<Student>;
  // StudentGroup hasMany GroupMembers via groupId
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
  // StudentGroup hasMany JoinRequest via groupId
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
  // StudentGroup belongsToMany Student via groupId and studentId
  studentIdStudents!: Student[];
  getStudentIdStudents!: Sequelize.BelongsToManyGetAssociationsMixin<Student>;
  setStudentIdStudents!: Sequelize.BelongsToManySetAssociationsMixin<Student, StudentId>;
  addStudentIdStudent!: Sequelize.BelongsToManyAddAssociationMixin<Student, StudentId>;
  addStudentIdStudents!: Sequelize.BelongsToManyAddAssociationsMixin<Student, StudentId>;
  createStudentIdStudent!: Sequelize.BelongsToManyCreateAssociationMixin<Student>;
  removeStudentIdStudent!: Sequelize.BelongsToManyRemoveAssociationMixin<Student, StudentId>;
  removeStudentIdStudents!: Sequelize.BelongsToManyRemoveAssociationsMixin<Student, StudentId>;
  hasStudentIdStudent!: Sequelize.BelongsToManyHasAssociationMixin<Student, StudentId>;
  hasStudentIdStudents!: Sequelize.BelongsToManyHasAssociationsMixin<Student, StudentId>;
  countStudentIdStudents!: Sequelize.BelongsToManyCountAssociationsMixin;

  static initModel(sequelize: Sequelize.Sequelize): typeof StudentGroup {
    return StudentGroup.init({
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    name: {
      type: DataTypes.STRING(40),
      allowNull: false
    },
    description: {
      type: DataTypes.STRING(100),
      allowNull: true
    },
    membersLimit: {
      type: DataTypes.SMALLINT,
      allowNull: true,
      field: 'members_limit'
    },
    isPublic: {
      type: DataTypes.BOOLEAN,
      allowNull: true,
      defaultValue: true,
      field: 'is_public'
    },
    gpa: {
      type: DataTypes.DECIMAL,
      allowNull: false
    },
    course: {
      type: DataTypes.STRING(60),
      allowNull: false
    },
    telegramLink: {
      type: DataTypes.STRING(100),
      allowNull: true,
      field: 'telegram_link'
    },
    telegramId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      field: 'telegram_id'
    },
    adminId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'student',
        key: 'student_id'
      },
      field: 'admin_id'
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
    tableName: 'student_group',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "student_group_pkey",
        unique: true,
        fields: [
          { name: "id" },
        ]
      },
    ]
  });
  }
}
