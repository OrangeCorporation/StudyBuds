import { Request } from 'express';
import { getStudentId } from '../middlewares/auth_middleware';
import StudentService from '../service/student_service';
import { NotFoundError } from '../utils/api_error';
import { validateInt } from '../utils/validation_error';

export async function getAllStudents(req: Request){
    return await StudentService.getAllStudents();
};

export async function getStudent(req: Request){
    const studentId = getStudentId(req);


    const student = await StudentService.getStudentById(studentId);
    if (student === null) {
        throw new NotFoundError('Student not found');
    }
    return student;
};

export async function editTelegramId(req: Request){
    const studentId = getStudentId(req);
    const telegramId = validateInt(req.body, "telegramAccount");
    const student = await StudentService.editTelegramIdService(studentId, telegramId);
    return {"id": student.studentId, "telegram_account": student.telegramAccount}
};


