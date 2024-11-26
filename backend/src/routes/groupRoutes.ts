import { Router } from 'express';
import { basicSearchResult, createGroup, getAllGroups } from '../controllers/groupController';
import {changeJoinRequestStatus, getAllRequests, joinTheGroup} from '../controllers/joinrequestContoller';


const router: Router = Router();

// Route to create a group
router.post('/create', createGroup);

// Route to fetch all groups
router.get('/all', getAllGroups);

router.get('/basic_search/:text/:student_id', basicSearchResult);

router.post('/join', joinTheGroup)

router.post('/respond-join-request', changeJoinRequestStatus)

router.get('/join-requests', getAllRequests);

export default router;
