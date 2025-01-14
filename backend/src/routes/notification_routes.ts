import { Router } from 'express';
import { getStudentsAllNotification, saveToken, testNotif } from '../controllers/notification_controller';
import { asyncWrapper } from '../utils/wrapper';


const router: Router = Router();

// Route to save firebase token
router.post('/token', asyncWrapper(saveToken));

// Route to fetch a student's all notification
router.get('/list', asyncWrapper(getStudentsAllNotification));

router.post('/test', asyncWrapper(testNotif));

export default router;