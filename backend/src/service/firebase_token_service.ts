import { FbToken } from "../models/FbToken";

export async function saveFbToken(studentId:number, token:string) {
    const result = await FbToken.create({
        studentId: studentId,
        token: token
    })
    return result;
}

export async function updateFbToken(studentId:number, token:string) {
    const result = await FbToken.update(
        { token: token},
        {
            where: {
                studentId: studentId
        }})
    return result;
}

export async function getStudentFirebaseToken(studentId:number) {
    return await FbToken.findOne({
        where:{
            studentId: studentId
        }
    });
}
