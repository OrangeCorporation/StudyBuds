import { Student } from '../models/Student';
import { NotFoundError } from '../utils/api_error';

export async function getAllStudents() {
    return await Student.findAll({
        attributes: ['studentId', 'telegramAccount'],
    });
};

export async function getStudentById(studentId: number) {
    return await Student.findByPk(studentId, {
        attributes: ['studentId', 'telegramAccount'],
    });
};

export async function editTelegramIdService(studentId: number, new_telegram_id: number) {
    // Fetch the student by their primary key
    const student = await Student.findByPk(studentId);

    // Handle case where student does not exist
    if (student === null) {
        throw new NotFoundError(`Student with ID ${studentId} not found`);
    }

    // Update the `telegramAccount` field with the new value
    student.telegramAccount = new_telegram_id;

    // Save the changes to the database
    await student.save();

    // Return the updated student object
    return student;
};



export default {
    getAllStudents,
    getStudentById,
    editTelegramIdService
};
