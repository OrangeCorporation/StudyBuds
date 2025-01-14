import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { Student, StudentId } from './Student';
import type { StudentGroup, StudentGroupId } from './StudentGroup';

export interface GroupMembersAttributes {
  studentId: number;
  groupId: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export type GroupMembersPk = "studentId" | "groupId";
export type GroupMembersId = GroupMembers[GroupMembersPk];
export type GroupMembersOptionalAttributes = "createdAt" | "updatedAt";
export type GroupMembersCreationAttributes = Optional<GroupMembersAttributes, GroupMembersOptionalAttributes>;

export class GroupMembers extends Model<GroupMembersAttributes, GroupMembersCreationAttributes> implements GroupMembersAttributes {
  studentId!: number;
  groupId!: number;
  createdAt?: Date;
  updatedAt?: Date;

  // GroupMembers belongsTo Student via studentId
  student!: Student;
  getStudent!: Sequelize.BelongsToGetAssociationMixin<Student>;
  setStudent!: Sequelize.BelongsToSetAssociationMixin<Student, StudentId>;
  createStudent!: Sequelize.BelongsToCreateAssociationMixin<Student>;
  // GroupMembers belongsTo StudentGroup via groupId
  group!: StudentGroup;
  getGroup!: Sequelize.BelongsToGetAssociationMixin<StudentGroup>;
  setGroup!: Sequelize.BelongsToSetAssociationMixin<StudentGroup, StudentGroupId>;
  createGroup!: Sequelize.BelongsToCreateAssociationMixin<StudentGroup>;

  static initModel(sequelize: Sequelize.Sequelize): typeof GroupMembers {
    return GroupMembers.init({
    studentId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      references: {
        model: 'student',
        key: 'student_id'
      },
      field: 'student_id'
    },
    groupId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true,
      references: {
        model: 'student_group',
        key: 'id'
      },
      field: 'group_id'
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
    tableName: 'group_members',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "group_members_pkey",
        unique: true,
        fields: [
          { name: "student_id" },
          { name: "group_id" },
        ]
      },
    ]
  });
  }
}
