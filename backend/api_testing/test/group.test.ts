import { expect, test } from "vitest";
import { initData, initDB } from "../../../test/utils/mock-data";
import axios from "axios";
import { BACKEND_URL } from "./utils";
import { Student } from "../../src/models/Student";

test("empty group creation prevented", async () => {
  initData();
  const student = new Student({ studentId: 4943369 });
  await initDB([student]);
  const actual = axios.post(`${BACKEND_URL}/groups/create`, {
    name: "",
    description: "",
    course: "",
    membersLimit: 10,
    telegramLink: "",
    studentId: student.studentId,
    isPublic: true,
  });
  await expect(actual).rejects.toThrowError();
});
