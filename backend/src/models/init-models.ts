import type { Sequelize } from "sequelize";
import { FbToken as _FbToken } from "./FbToken";
import type { FbTokenAttributes, FbTokenCreationAttributes } from "./FbToken";
import { GroupMembers as _GroupMembers } from "./GroupMembers";
import type { GroupMembersAttributes, GroupMembersCreationAttributes } from "./GroupMembers";
import { JoinRequest as _JoinRequest } from "./JoinRequest";
import type { JoinRequestAttributes, JoinRequestCreationAttributes } from "./JoinRequest";
import { Notification as _Notification } from "./Notification";
import type { NotificationAttributes, NotificationCreationAttributes } from "./Notification";
import { Student as _Student } from "./Student";
import type { StudentAttributes, StudentCreationAttributes } from "./Student";
import { StudentGroup as _StudentGroup } from "./StudentGroup";
import type { StudentGroupAttributes, StudentGroupCreationAttributes } from "./StudentGroup";

export {
  _FbToken as FbToken,
  _GroupMembers as GroupMembers,
  _JoinRequest as JoinRequest,
  _Notification as Notification,
  _Student as Student,
  _StudentGroup as StudentGroup,
};

export type {
  FbTokenAttributes,
  FbTokenCreationAttributes,
  GroupMembersAttributes,
  GroupMembersCreationAttributes,
  JoinRequestAttributes,
  JoinRequestCreationAttributes,
  NotificationAttributes,
  NotificationCreationAttributes,
  StudentAttributes,
  StudentCreationAttributes,
  StudentGroupAttributes,
  StudentGroupCreationAttributes,
};

export function initModels(sequelize: Sequelize) {
  const FbToken = _FbToken.initModel(sequelize);
  const GroupMembers = _GroupMembers.initModel(sequelize);
  const JoinRequest = _JoinRequest.initModel(sequelize);
  const Notification = _Notification.initModel(sequelize);
  const Student = _Student.initModel(sequelize);
  const StudentGroup = _StudentGroup.initModel(sequelize);

  Student.belongsToMany(StudentGroup, { as: 'groupIdStudentGroups', through: GroupMembers, foreignKey: "studentId", otherKey: "groupId" });
  StudentGroup.belongsToMany(Student, { as: 'studentIdStudents', through: GroupMembers, foreignKey: "groupId", otherKey: "studentId" });
  Notification.belongsTo(JoinRequest, { as: "joinRequest", foreignKey: "joinRequestId"});
  JoinRequest.hasMany(Notification, { as: "notifications", foreignKey: "joinRequestId"});
  FbToken.belongsTo(Student, { as: "student", foreignKey: "studentId"});
  Student.hasMany(FbToken, { as: "fbTokens", foreignKey: "studentId"});
  GroupMembers.belongsTo(Student, { as: "student", foreignKey: "studentId"});
  Student.hasMany(GroupMembers, { as: "groupMembers", foreignKey: "studentId"});
  JoinRequest.belongsTo(Student, { as: "student", foreignKey: "studentId"});
  Student.hasMany(JoinRequest, { as: "joinRequests", foreignKey: "studentId"});
  Notification.belongsTo(Student, { as: "student", foreignKey: "studentId"});
  Student.hasMany(Notification, { as: "notifications", foreignKey: "studentId"});
  StudentGroup.belongsTo(Student, { as: "admin", foreignKey: "adminId"});
  Student.hasMany(StudentGroup, { as: "studentGroups", foreignKey: "adminId"});
  GroupMembers.belongsTo(StudentGroup, { as: "group", foreignKey: "groupId"});
  StudentGroup.hasMany(GroupMembers, { as: "groupMembers", foreignKey: "groupId"});
  JoinRequest.belongsTo(StudentGroup, { as: "group", foreignKey: "groupId"});
  StudentGroup.hasMany(JoinRequest, { as: "joinRequests", foreignKey: "groupId"});

  return {
    FbToken: FbToken,
    GroupMembers: GroupMembers,
    JoinRequest: JoinRequest,
    Notification: Notification,
    Student: Student,
    StudentGroup: StudentGroup,
  };
}
