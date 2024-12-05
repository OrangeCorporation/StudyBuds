import { StudentAttributes } from "../models/Student";
import { getStudentById } from "../service/student_service";
import { getUnigeProfile,UnigeStudent } from "./unige_service";
import { NotFoundError } from "../utils/api_error";

interface ProfileData extends StudentAttributes,UnigeStudent{}

export async function getProfileService(studentId: number):Promise<ProfileData> {
  const data = await getUnigeProfile(studentId);


  console.log(studentId);

  const student = await getStudentById(studentId);
  if(student===null)throw new NotFoundError("Student id not found");

  return {...data,...student};
}
