
const { getAllStudent, getStudentById } = require('../service/student_service');
const { getGroupData } = require('../service/group_service')
const { getGroupMembersCnt, addNewGroupMember } = require('../service/group_member')
const { ApiError, errorCodes } = require('../utils/response');


const getAllStudents = async (req,res)=>{
    try {
        const { groupId, studentId } = req.body
        const student = await getStudentById(studentId)
        if (student.telegram_account == null)
            throw new ApiError({code: errorCodes.validationErrorCode, message : 'You need to link your telegram account'})
        const group = await getGroupData(groupId)
        if (group == null)
            throw new ApiError({code: errorCodes.notFoundErrorCode})
        const currentMembersCnt = await getGroupMembersCnt(groupId)
        if (group.members_limit < currentMembersCnt + 1)
            throw new ApiError({code: errorCodes.validationErrorCode, message : 'The group is already exceeded'})
        if (group.is_public) {
            // TODO add query of Entity to the Group Members Table
            
        }
        const result = await getAllStudent();
        res.status(200).send({
            data: result
        })
    } catch (err) {
        console.log(err)
        res.status(err.status || 500);
        res.send(err.message || 'Internal server error');
    }
};