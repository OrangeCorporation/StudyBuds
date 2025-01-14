import {Before, Then} from "@cucumber/cucumber";
import assert from "assert";
import { byValueKey } from "appium-flutter-finder"; // Adjust imports as necessary
import { driver } from "./all";
import {initDB} from "../utils/mock-data.ts";
import {Student} from "../../backend/src/models/Student.ts";
import {StudentGroup} from "../../backend/src/models/StudentGroup.ts";
import {GroupMembers} from "../../backend/src/models/GroupMembers.ts";

Before({tags: "@receive-suggested-groups"},async function () {
    const student=11;
    const group=40;
    const student1=10;
    const group1=36;
    await initDB([
        new Student({studentId: student1,telegramAccount:36}),
        new Student({studentId: student,telegramAccount:39}),
        new StudentGroup({id:group1,name:"capstone1",description:"test description",course:"Capstone",adminId:student1,membersLimit:10,isPublic:false,gpa:18}),
        new StudentGroup({id:group,name:"capstone2",description:"test description",course:"Capstone",adminId:student1,membersLimit:100,isPublic:false,gpa:20}),
        new GroupMembers({studentId: student1,groupId: group1}),
        new GroupMembers({studentId: student,groupId: group1}),
        new GroupMembers({studentId: student1,groupId: group}),
    ])
});


// Then step - Verify the search results contain groups matching the search term
Then("I see some suggested groups", async function () {
    const suggestedGroupKeyPrefix = "suggested_group_name_";
    const maxGroupsToCheck = 10; // Maximum number of groups to check
    let groupsFound = false;

    for (let i = 0; i < maxGroupsToCheck; i++) {
        const groupKey = byValueKey(`${suggestedGroupKeyPrefix}${i}`);
        try {

            const groupName = await driver.execute("flutter:waitFor", groupKey, 5000);

            console.log(`Suggested group ${i} name: ${groupName}`);

            // If at least one group is found, mark as successful
            groupsFound = true;
        } catch (error) {
            console.log(`Group ${i} not found.` + error);
            break; // Stop checking if no more groups are found
        }
    }

    // Assert that at least one suggested group is found
    assert.ok(groupsFound, "No suggested groups were found.");
});