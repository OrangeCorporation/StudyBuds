import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { JoinRequest, JoinRequestId } from './JoinRequest';
import type { Student, StudentId } from './Student';

export interface NotificationAttributes {
  id: number;
  studentId: number;
  joinRequestId: number;
  notificationType: "join_request" | "accept" | "reject";
  message: string;
  createdAt?: Date;
  updatedAt?: Date;
}

export type NotificationPk = "id";
export type NotificationId = Notification[NotificationPk];
export type NotificationOptionalAttributes = "id" | "createdAt" | "updatedAt";
export type NotificationCreationAttributes = Optional<NotificationAttributes, NotificationOptionalAttributes>;

export class Notification extends Model<NotificationAttributes, NotificationCreationAttributes> implements NotificationAttributes {
  id!: number;
  studentId!: number;
  joinRequestId!: number;
  notificationType!: "join_request" | "accept" | "reject";
  message!: string;
  createdAt?: Date;
  updatedAt?: Date;

  // Notification belongsTo JoinRequest via joinRequestId
  joinRequest!: JoinRequest;
  getJoinRequest!: Sequelize.BelongsToGetAssociationMixin<JoinRequest>;
  setJoinRequest!: Sequelize.BelongsToSetAssociationMixin<JoinRequest, JoinRequestId>;
  createJoinRequest!: Sequelize.BelongsToCreateAssociationMixin<JoinRequest>;
  // Notification belongsTo Student via studentId
  student!: Student;
  getStudent!: Sequelize.BelongsToGetAssociationMixin<Student>;
  setStudent!: Sequelize.BelongsToSetAssociationMixin<Student, StudentId>;
  createStudent!: Sequelize.BelongsToCreateAssociationMixin<Student>;

  static initModel(sequelize: Sequelize.Sequelize): typeof Notification {
    return Notification.init({
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
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
    joinRequestId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'join_request',
        key: 'id'
      },
      field: 'join_request_id'
    },
    notificationType: {
      type: DataTypes.ENUM("join_request","accept","reject"),
      allowNull: false,
      field: 'notification_type'
    },
    message: {
      type: DataTypes.STRING(50),
      allowNull: false
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
    tableName: 'notification',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "notification_pkey",
        unique: true,
        fields: [
          { name: "id" },
        ]
      },
    ]
  });
  }
}
