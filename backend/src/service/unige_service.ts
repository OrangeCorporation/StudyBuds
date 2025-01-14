import axios from "axios";
import { axios_instance, TOKEN, UNIGEAPI_URL } from "../config/unigeapi";

export async function getCourses(): Promise<Array<string>> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return (
        await axios_instance.get(`${UNIGEAPI_URL}/courses`, {
            headers: {
                Authorization: `Bearer ${TOKEN}`,
            },
        })
    ).data;
}

export interface UnigeStudent {
    first_name: string;
    last_name: string;
    email: string;
    id: number;
    password: string;
    gpa: number;
    study_plan: Array<string>;
    exams_to_take: Array<string>;
    courses: Array<string>;
}


export async function getUnigeProfile(studentId: number): Promise<UnigeStudent> {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-return
    return (
        await axios_instance.get(`${UNIGEAPI_URL}/student/${studentId}`, {
            headers: {
                Authorization: `Bearer ${TOKEN}`,
            },
        })
    ).data;
}

export async function getStudentsUnigeProfiles(studentIds: Array<number>): Promise<Array<UnigeStudent>> {
    return (
        await axios.post(`${UNIGEAPI_URL}/students`,
        studentIds,
        {
            headers: {
                Authorization: `Bearer ${TOKEN}`,
            }
        })
    ).data;
}

export async function calculateAverageGpa(studentList: Array<number>): Promise<{ average_gpa: number }> {
    return( await axios.post(
        `${UNIGEAPI_URL}/students/gpa`,
        studentList,
        {
            headers: {
                Authorization: `Bearer ${TOKEN}`,
            },
        })
    ).data;
}


const UnigeService = {
    getCourses,
    getUnigeProfile,
    getStudentsUnigeProfiles
};

export default UnigeService;
