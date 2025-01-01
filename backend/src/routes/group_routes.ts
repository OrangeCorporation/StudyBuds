import { Router } from 'express';
import { basicSearchResult, createGroup, getAllGroups, getGroupDetails, getSuggestedGroupList } from '../controllers/group_controller';
import { changeJoinRequestStatus, joinTheGroup } from '../controllers/joinrequest_controller';
import { asyncWrapper } from '../utils/wrapper';
import { getJoinedGroupList } from '../controllers/joined_group_list_controller';


const router: Router = Router();

// Route to create a group
router.post('/create', asyncWrapper(createGroup));

// Route to fetch all groups
router.get('/all', asyncWrapper(getAllGroups));

router.get('/basic_search/:text/:student_id', asyncWrapper(basicSearchResult));

router.post('/join', asyncWrapper(joinTheGroup))

router.post('/respond_join_request', asyncWrapper(changeJoinRequestStatus))


router.get('/group_details/:groupId', asyncWrapper(getGroupDetails));

router.get('/joined_groups/:studentId', asyncWrapper(getJoinedGroupList));

router.get('/group_suggestions/:student_id', asyncWrapper(getSuggestedGroupList));

export default router;

