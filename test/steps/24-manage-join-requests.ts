import {Before, Given, Then, When} from "@cucumber/cucumber";
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
import { driver } from "./all";
import {initDB} from "../utils/mock-data.ts";
import { Student } from "../../backend/src/models/Student.ts";
import { StudentGroup } from "../../backend/src/models/StudentGroup.ts";
import { GroupMembers } from "../../backend/src/models/GroupMembers.ts";
import { JoinRequest } from "../../backend/src/models/JoinRequest.ts";
import { Notification } from "../../backend/src/models/Notification.ts";

// let driver:WebdriverIO.Browser;
// Before(()=>driver=getDriver())

Before({tags: "@manage-join-requests"},async function () {
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

Given("I am a SuperStudent of a group", async function () {});

Given("a student sends a join request to that group", async function () {});

When("I go to the notifications page", async function () {
    await go_to_page(driver, BottomBarIcon.notifications);
});

Then("I see the notification with id {string} with the {string} message", async function (id: string, message: string) {
    const notification = await byValueKey("notification_"+id);
    const itemText = await driver.getElementText(notification);
    assert.ok(itemText === message);
});

When("I open the notification with id {string}", async function (id: string) {
    await waitForElement(driver, `btn_${id}`);
    await clickButton(driver, `btn_${id}`);
});

When("I click accept", async function () {
    await waitForElement(driver, "accept");
    console.log("Waiting accept");
    await clickButton(driver, "accept");
    console.log("Clicked accept");
});

When("I click refuse", async function () {
    await waitForElement(driver, "reject");
    await clickButton(driver, "reject");
});

Then("The user receives the invitation link of Telegram group", async function () {});

Then("a notification is sent to him", async function () {
    await waitForElement(driver, "success_toast");
    const actual = await getText(driver, "success_toast");
    const expected = "Join request accepted successfully";
    assert.ok(actual === expected);
});

Then("The user does not receive the invitation link of Telegram group", async function () {});
Then("a notification is sent to him about the refusal", async function () {
    await waitForElement(driver, "success_toast");
    const actual = await getText(driver, "success_toast");
    const expected = "Join request rejected successfully";
    assert.ok(actual === expected);
});
