import { QueryTypes, Op } from "sequelize";
import sequelize from "../config/database";
import UnigeService from "./unige_service";
import { StudentGroup } from "../models/StudentGroup";
import { getErrorMessage } from "../utils/api_error";




export async function getSuggestedGroupsbyCourses(student_id: number) {

    const student_info = await UnigeService.getUnigeProfile(student_id);

    const courses = student_info.courses;

    const data = await StudentGroup.findAll({
        where: {
            course: {
                [Op.iLike]: {
                    [Op.any]: courses,
                },
            },
        },
    });

    return data;
}


export async function getSuggestedGroupsbyPopularity(): Promise<StudentGroup[]> {

    const query = `
      REFRESH MATERIALIZED VIEW studybuds.group_popularity;
      SELECT *
      FROM (SELECT * 
            FROM studybuds.group_popularity 
            ORDER BY members DESC) ordered_view left join studybuds.student_group on ordered_view.group_id = studybuds.student_group.id;
    `;

    try {
        const results = await sequelize.query<StudentGroup[]>(query, {
            type: QueryTypes.SELECT,
        });
        return results;
    } catch (error) {
        console.error(`Failed to execute basic search. Error: ${getErrorMessage(error)}`);
        throw error;
    }

}


export async function getSuggestedGroupsbyFriends(student_id: number): Promise<StudentGroup[]> {

    const query = `
      SELECT group_id, count(*) as tot
      FROM studybuds.group_members
      WHERE student_id in
      (
        SELECT  DISTINCT student_id
        FROM studybuds.group_members
        WHERE group_id in 
        (
            SELECT DISTINCT group_id 
            FROM studybuds.group_members
            WHERE student_id=:student_id
        )
        AND student_id not in (:student_id)
      )
      GROUP BY group_id ORDER BY tot DESC
    `;
    try {
        const results = await sequelize.query<StudentGroup[]>(query, {
            replacements: { student_id },
            type: QueryTypes.SELECT,
        });
        return results;
    } catch (error) {
        console.error(`Failed to execute get suggested groups by friends. Error: ${getErrorMessage(error)}`);
        throw error;
    }

}

export async function getSuggestedGroupsByGpa(): Promise<StudentGroup[]> {

    const data = await StudentGroup.findAll({
        order: [['gpa', 'DESC']],
    });

    return data;
}
