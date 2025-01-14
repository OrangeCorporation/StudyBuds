import { expect, test } from "vitest";
import { initData, initDB } from "../../../test/utils/mock-data";
import axios from "axios";
import { Student } from "../../src/models/Student";
import { StudentGroup } from "../../src/models/StudentGroup";
import { GroupMembers } from "../../src/models/GroupMembers";
import { BACKEND_URL, getToken } from "./utils";

test("empty", async () => {
  initData();
  const student = new Student({ studentId: 10 });
  const student1 = new Student({ studentId: 4943369 });
  const student2 = new Student({ studentId: 4943370 });
  const group1 = new StudentGroup({
    id: 1,
    name: "CP",
    gpa: 0,
    course: "Capstone",
    adminId: student1.studentId,
  });
  const group2 = new StudentGroup({
    id: 2,
    name: "CP2",
    gpa: 0,
    course: "Capstone",
    adminId: student2.studentId,
  });
  await initDB([
    student,
    student1,
    student2,
    group1,
    group2,
    new GroupMembers({ studentId: student1.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student1.studentId, groupId: group2.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group2.id }),
  ]);
  const expected = { joinedGroups: [], ownedGroups: [] };
  const actual = (
    await axios.get(`${BACKEND_URL}/groups/joined_groups`, {
      headers: { Authorization: `Bearer ${getToken(student.studentId)}` },
    })
  ).data;
  expect(actual).toEqual(expected);
});

test("data", async () => {
  initData();
  const student1 = new Student({ studentId: 4943369 });
  const student2 = new Student({ studentId: 4943370 });
  const group1 = new StudentGroup({
    id: 1,
    name: "CP",
    gpa: 0,
    course: "Capstone",
    telegramLink: "https://t.me/joinrequest",
    adminId: student1.studentId,
  });
  const group2 = new StudentGroup({
    id: 2,
    name: "CP2",
    gpa: 0,
    course: "Capstone",
    telegramLink: "https://t.me/joinrequest2",
    adminId: student2.studentId,
  });
  await initDB([
    student1,
    student2,
    group1,
    group2,
    new GroupMembers({ studentId: student1.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student1.studentId, groupId: group2.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group2.id }),
  ]);
  const expected = {
    ownedGroups: [
      {
        id: group1.id,
        name: group1.name,
        description: null,
        course: group1.course,
        telegramLink: group1.telegramLink,
        isPublic: true,
        membersCount: 2,
      },
    ],
    joinedGroups: [
      {
        id: group2.id,
        name: group2.name,
        description: null,
        course: group2.course,
        telegramLink: group2.telegramLink,
        isPublic: true,
        membersCount: 2,
      },
    ],
  };
  console.error(`${BACKEND_URL}/groups/joined_groups`);
  const actual = (
    await axios.get(`${BACKEND_URL}/groups/joined_groups`, {
      headers: { Authorization: `Bearer ${getToken(student1.studentId)}` },
    })
  ).data;
  expect(actual).toEqual(expected);
});

test("data2", async () => {
  initData();
  const student1 = new Student({ studentId: 4943369 });
  const student2 = new Student({ studentId: 4943370 });
  const group1 = new StudentGroup({
    id: 1,
    name: "CP",
    gpa: 0,
    course: "Capstone",
    telegramLink: "https://t.me/joinrequest",
    adminId: student1.studentId,
  });
  const group2 = new StudentGroup({
    id: 2,
    name: "CP2",
    gpa: 0,
    course: "Capstone",
    telegramLink: "https://t.me/joinrequest2",
    adminId: student2.studentId,
  });
  await initDB([
    student1,
    student2,
    group1,
    group2,
    new GroupMembers({ studentId: student1.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group1.id }),
    new GroupMembers({ studentId: student1.studentId, groupId: group2.id }),
    new GroupMembers({ studentId: student2.studentId, groupId: group2.id }),
  ]);
  const expected = {
    ownedGroups: [
      {
        id: group2.id,
        name: group2.name,
        description: null,
        course: group2.course,
        telegramLink: group2.telegramLink,
        isPublic: true,
        membersCount: 2,
      },
    ],
    joinedGroups: [
      {
        id: group1.id,
        name: group1.name,
        description: null,
        course: group1.course,
        telegramLink: group1.telegramLink,
        isPublic: true,
        membersCount: 2,
      },
    ],
  };
  const actual = (
    await axios.get(`${BACKEND_URL}/groups/joined_groups`, {
      headers: { Authorization: `Bearer ${getToken(student2.studentId)}` },
    })
  ).data;
  expect(actual).toEqual(expected);
});
