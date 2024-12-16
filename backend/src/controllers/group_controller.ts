import { Request } from "express";
import GroupService from "../service/group_service";
import { BadRequestError, NotFoundError } from "../utils/api_error";
import UnigeService from "../service/unige_service";

import {
    checkBoolean,
    checkInt,
    checkString,
    IndexSignature,
    validateInt,
    validateString,
} from "../utils/validation_error";
import { Student } from "../models/Student";
import { StudentGroup } from "../models/StudentGroup";
import { GroupMembers } from "../models/GroupMembers";

// Function to create a group
export async function createGroup(req: Request) {
    const body = req.body as IndexSignature;
    const name = checkString(body, "name");
    const description = checkString(body, "description");
    const course = checkString(body, "course");
    const membersLimit = checkInt(body, "membersLimit");
    const telegramLink = checkString(body, "telegramLink");
    const studentId = checkInt(body, "studentId");
    const isPublic = checkBoolean(body, "isPublic");

    // Validate if the student exists
    const student = await Student.findByPk(studentId);
    if (!student) {
        throw new NotFoundError("Student not found");
    }

    // Check if the telegramLink already exists
    const existingGroup = await StudentGroup.findOne({ where: { telegramLink } });
    if (existingGroup) {
        throw new BadRequestError("This Telegram link already exists");
    }

    // Create the group using GroupService
    const group = await GroupService.createGroup({
        name,
        description,
        course,
        isPublic,
        membersLimit,
        telegramLink,
        adminId: studentId, // Maps studentId to adminId
    });

    return { message: "Group created successfully", group };
}

// Function to get all groups
export async function getAllGroups(req: Request) {
    return await StudentGroup.findAll();
}

export async function basicSearchResult(req: Request) {
    const text = validateString(req.params, "text");
    const student_id = validateInt(req.params, "student_id");
    const result = await GroupService.basicSearch(text, student_id);
    console.log(result);
    return result;
}

// Function to get group details
export async function getGroupDetails(req: Request) {
    const groupId = validateInt(req.params, "groupId");

    // Fetch group information
    const group = await StudentGroup.findByPk(groupId);

    if (!group) {
        throw new NotFoundError("Group not found");
    }

    // Fetch group members from the GroupMembers table
    const members = await GroupMembers.findAll({ where: { groupId } });

    // Prepare student details by fetching individually from UnigeMockup
    const groupMembers = [];

    if (members.length === 0) {
        // throw new NotFoundError("Group members not found");
    }else {
        for (const member of members) {
            const studentDetail = await UnigeService.getUnigeProfile(member.studentId); // Ensure proper import
            groupMembers.push({
                studentId: studentDetail.id,
                firstName: studentDetail.first_name,
                lastName: studentDetail.last_name,
            });
        }

    }

    // Format response
    const response = {
        groupId: group.id,
        name: group.name,
        description: group.description,
        isPublic: group.isPublic,
        telegramLink: group.telegramLink,
        studentId: group.adminId, // Admin student ID
        members: members.length, // Current members count
        membersLimit: group.membersLimit, // Group member limit
        groupMembers, // List of student details
    };

    return response;
}

export default {
    createGroup,
    getAllGroups,
    basicSearchResult,
    getGroupDetails,
};
