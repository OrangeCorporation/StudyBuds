import { Router } from 'express';
import { getAllStudents, getStudent } from '../controllers/student_controller';
import { asyncWrapper } from '../utils/wrapper';

const router: Router = Router();

// Route to get all students (specific to /students/all)
router.get('/all', asyncWrapper(getAllStudents)); // Change the path to avoid overlap

// Route to get a student by ID
router.get('', asyncWrapper(getStudent));




export default router;
