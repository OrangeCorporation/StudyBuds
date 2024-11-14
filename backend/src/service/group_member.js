const pool = require('../../db');
const { ApiError, errorCodes } = require('../utils/response');

async function getStudentsGroup(student_id) {
    try {
        const data = await pool.query('select * from study_buds.studentsGroupMember where student_id=$1',[student_id])
        return data.rows;
    } catch (e) {
        console.log(`Failed to get student's groups request error: ${e}`);
        throw new ApiError({code: errorCodes.internalServerErrorCode});
    }
}

async function getGroupMembersCnt(group_id) {
    try {
        const data = await pool.query('select count(*) from stud_buds.studentsGroupMember where students_group_id=$1', [group_id])
        return data.rows;
    } catch (e) {
        console.log(`Failed to count students group members, groupId:${group_id}`)
        throw new ApiError({code: errorCodes.internalServerErrorCode});
    }

}
async function addNewGroupMember(group_id){
    try{
        console.log('');
        // const addMembr = await pool.query('insert into ()  ')
    } catch(e){}
}
module.exports = {
    getStudentsGroup,
    getGroupMembersCnt
}