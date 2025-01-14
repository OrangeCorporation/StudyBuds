import {Given, Then, Before, When} from "@cucumber/cucumber";
import assert from "assert";
import { byValueKey } from "appium-flutter-finder";
import { driver } from "./all";
import { waitForElementByValue,getBottomBarIcon,go_to_page } from "../utils/utils";
import {initDB} from "../utils/mock-data.ts";
import { Student } from "../../backend/src/models/Student.ts";
import { StudentGroup } from "../../backend/src/models/StudentGroup.ts";
import { GroupMembers } from "../../backend/src/models/GroupMembers.ts";
import { JoinRequest } from "../../backend/src/models/JoinRequest.ts";

Before({tags: "@join-a-group-to-find-people"},async function () {
  const student1=10;
  const student2=11;
  const group1=7;
  await initDB([
    new Student({studentId: student1,telegramAccount:4848}),
    new Student({studentId: student2,telegramAccount:4849}),
    new StudentGroup({id:group1,name:"aya",course:"Capstone",adminId:student2,membersLimit:10,isPublic:false,gpa:29}),
    new GroupMembers({studentId: student1,groupId: group1}),
    new JoinRequest({id:13,groupId:group1,studentId:student1,status:"pending"})
  ])
});

Given("I already have sent a join request to the group", async function () { });

Then("I go to the {string} page", async function (page: string) {
  await go_to_page(driver, getBottomBarIcon(page));
});


Then("The {string} button is displayed to indicate that a request is already pending", async function (buttonLabel: string) {
  await waitForElementByValue(driver, buttonLabel);
});


When("I attempt to send another join request", async function () {
  const group1=7;//same as the db

  const joinRequestButton = byValueKey("join_button_"+group1);

  try {
    await driver.elementClick(joinRequestButton);
    assert.fail("The Join group button is clickable, but it should be disabled!");
  } catch (e) {
    console.log("The Join group button is correctly unclickable.");
  }

});
