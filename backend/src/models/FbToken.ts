import * as Sequelize from 'sequelize';
import { DataTypes, Model, Optional } from 'sequelize';
import type { Student, StudentId } from './Student';

export interface FbTokenAttributes {
  id: number;
  token: string;
  studentId: number;
  createdAt?: Date;
  updatedAt?: Date;
}

export type FbTokenPk = "id";
export type FbTokenId = FbToken[FbTokenPk];
export type FbTokenOptionalAttributes = "id" | "createdAt" | "updatedAt";
export type FbTokenCreationAttributes = Optional<FbTokenAttributes, FbTokenOptionalAttributes>;

export class FbToken extends Model<FbTokenAttributes, FbTokenCreationAttributes> implements FbTokenAttributes {
  id!: number;
  token!: string;
  studentId!: number;
  createdAt?: Date;
  updatedAt?: Date;

  // FbToken belongsTo Student via studentId
  student!: Student;
  getStudent!: Sequelize.BelongsToGetAssociationMixin<Student>;
  setStudent!: Sequelize.BelongsToSetAssociationMixin<Student, StudentId>;
  createStudent!: Sequelize.BelongsToCreateAssociationMixin<Student>;

  static initModel(sequelize: Sequelize.Sequelize): typeof FbToken {
    return FbToken.init({
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    token: {
      type: DataTypes.STRING(200),
      allowNull: false
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
    tableName: 'fb_token',
    schema: 'studybuds',
    timestamps: false,
    indexes: [
      {
        name: "fb_token_pkey",
        unique: true,
        fields: [
          { name: "id" },
        ]
      },
    ]
  });
  }
}
