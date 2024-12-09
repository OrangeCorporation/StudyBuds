import { DataTypes } from "sequelize";
import { Column, Model, Table } from "sequelize-typescript";
import sequelize from "../config/database";

export enum NotificationType {
  JOIN_REQUEST = "join_request",
  ACCEPT = "accept",
  REJECT = "reject",
}

@Table({
  tableName: "notification",
  schema: "studybuds",
  timestamps: true,
  createdAt: "created_at",
  updatedAt: "updated_at",
})
class Notification extends Model {
  @Column({
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  })
  public override id!: number;
  @Column({
    type: DataTypes.INTEGER,
    allowNull: false,
    field: "student_id",
  })
  public studentId!: number;
  @Column({
    type: DataTypes.INTEGER,
    allowNull: false,
    field: "join_request_id",
  })
  public joinRequestId!: number;
  @Column({
    type: DataTypes.STRING(20),
    allowNull: false,
    field: "notification_type",
  })
  public notificationType!: NotificationType;
  @Column({
    type:DataTypes.STRING(50),
    allowNull: false,
    field: "message",
  })
  public message!: String
}

sequelize.addModels([Notification]);

export default Notification;
