import { byValueKey } from "appium-flutter-finder";
import { waitForElement, getUiId } from "./../utils/utils";
import {When, Then, Before} from "@cucumber/cucumber";
import { driver } from "./all";
import {initDB} from "../utils/mock-data.ts";
import {Student} from "../../backend/src/models/Student.ts";
import {StudentGroup} from "../../backend/src/models/StudentGroup.ts";
import {GroupMembers} from "../../backend/src/models/GroupMembers.ts";

// let driver:WebdriverIO.Browser;
// Before(()=>driver=getDriver())

/*
    TODO
    WHEN LOGOUT IS IMPLEMENTED REMOVE THE GUEST LOGIN AND USE THESE LINES FOR THE GHERKIN

    Given I am on the home page not logged in
    And I click on the login button
    And I input my Unige credentials username "10" and password "10"

*/



Before({tags: "@joined-group-list"},async function () {
    const student=42674;
    const student1=42675;
    const student2=10;
    const group=104;
    const group1=105;

    await initDB([
        new Student({studentId: student,telegramAccount:1435}),
        new Student({studentId: student1,telegramAccount:1436}),
        new Student({studentId: student2,telegramAccount:35}),
        //new StudentGroup({id:group,name:"mygroupyes",description:"description",course:"Capstone",adminId:student,membersLimit:10,isPublic:false,gpa:20}),
        //new GroupMembers({studentId: student,groupId: group}),
        new StudentGroup({id:group1,name:"groupof10",description:"description",course:"Capstone",adminId:student2,membersLimit:100,isPublic:false,gpa:18}),
        new GroupMembers({studentId: student,groupId: group1}),
        new GroupMembers({studentId: student2,groupId: group1}),
    ])
});

When("I navigate to the {string} tab", async (tab:string) => {
    const groupTab = await byValueKey(getUiId(tab));
    await driver.elementClick(groupTab);
});

Then("I see a list of all groups I am part of", async () => {});


Then("The groups I own are there", async () => {
    await waitForElement(driver, "group_name_0");
});
