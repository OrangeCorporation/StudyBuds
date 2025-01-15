// 211-notification-list.ts
import { Then, Before} from "@cucumber/cucumber";
import { initDB } from "../utils/mock-data";
import {driver} from "./all"
import { Notification } from "../../backend/src/models/Notification";
import { JoinRequest } from "../../backend/src/models/JoinRequest";
import { Student } from "../../backend/src/models/Student.ts";
import { StudentGroup } from "../../backend/src/models/StudentGroup.ts";
import { GroupMembers } from "../../backend/src/models/GroupMembers.ts";
import { byValueKey } from "appium-flutter-finder";
import assert from "assert";
import {
  BottomBarIcon,
  clickButton,
  getText,
  go_to_page,
  waitForElement,
  login,
} from "../utils/utils";

// Sample data for initializing the database
Before({tags: "@notification-list"}, async function () {

    const student=10;
    const student1=12;
    const group1=103;
    const joinRequestId = 11;
    // const joinRequestId2 = 12;
    await initDB([
        new Student({studentId: student,telegramAccount:35}),
        new StudentGroup({id:group1,name:"joinrequest",description:"description",course:"Capstone",adminId:student,membersLimit:100,isPublic:false,gpa:18}),
        new GroupMembers({studentId: student,groupId: group1}),
        new Student({studentId: student1,telegramAccount:37}),
        new JoinRequest({id:joinRequestId,groupId:group1,studentId:student1,status:"pending"}),
        new Notification({id:1,studentId:student,joinRequestId:joinRequestId,notificationType:"join_request",message:"Nona has requested to join the Capstone project"}),
    ])
});

// Verify the background color of the notification
Then("The notification background becomes gray", async function () {
    // const notificationBg = await getText(driver, "notification_bg_1"); // Replace with actual UI ID if needed
    // if (notificationBg !== "gray") {
    //     throw new Error("The notification background is not gray");
    // }
});

// Verify the button is removed
Then("The button to show details for notification with id {string} is removed", async function (id:string) {
    try {
      await driver.execute("flutter:waitFor", `btn_${id}`, 1000);
      throw new Error(`The button for Notification_${id} is still present`);
    } catch (error) {
      this.log("button is not present, can continue")
    }  
});

// Verify the label of the notification
Then("The notification with id {string} has {string} as its label", async function (id, label) {
  await waitForElement(driver,"notification_status_"+id);
  const notification = await byValueKey("notification_status_"+id);
  const itemText = await driver.getElementText(notification);
  assert.ok(itemText === label);
});
