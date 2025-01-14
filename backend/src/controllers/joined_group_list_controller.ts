import { Request } from "express";
import { getStudentId } from "../middlewares/auth_middleware";
import { getJoinedGroupList as joinedGroupListService } from "../service/joined_group_list_service";

export async function getJoinedGroupList(req: Request) {

    console.log('============');
    const studentId = getStudentId(req);
    console.log(studentId);
    return await joinedGroupListService(studentId);
}
