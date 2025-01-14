import { Request } from "express";
import { getStudentId } from "../middlewares/auth_middleware";
import { getProfileService } from "../service/profile_service";

export async function getProfileById(req: Request) {
  const studentId = getStudentId(req);

  const result = await getProfileService(studentId);
  // Remove the 'courses' field
  const { courses, ...dataWithoutCourses } = result;
  return dataWithoutCourses
};
