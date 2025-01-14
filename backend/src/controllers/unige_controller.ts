import { Request } from "express";
import { getStudentId } from "../middlewares/auth_middleware";
import { getCourses } from "../service/unige_service";

export async function getCourseList(req: Request) {
  const studentId = getStudentId(req);
  console.log(studentId);
  return await getCourses();
}
