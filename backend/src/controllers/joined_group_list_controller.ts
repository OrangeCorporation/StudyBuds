import { Request } from "express";
import { validateInt } from "../utils/validation_error";
import {getJoinedGroupList as joinedGroupListService} from "../service/joined_group_list_service"

export async function getJoinedGroupList(req: Request) {
    const studentId=validateInt(req.params,"studentId");
    return await joinedGroupListService(studentId);
}
