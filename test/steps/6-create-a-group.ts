import {Given, When, Then, Before} from "@cucumber/cucumber";
import { BottomBarIcon, clickButton, getText, go_to_page, waitForElement, waitForElementByValue, clickDropdownItemByValue, editTextField, getUiId, UiId } from "../utils/utils";
import { driver } from "./all";
import assert from "assert";
import {initDB} from "../utils/mock-data.ts";
import {Student} from "../../backend/src/models/Student.ts";
import {byType, byValueKey} from "appium-flutter-finder";



Before({tags: "@create-a-group"},async function () {
    const student1=10;
    await initDB([
        new Student({studentId: student1,telegramAccount:4848})
    ])
});

When("I fill out the {string} with {string}", async function (field: string, value: string) {
    console.log("Filling out the field: " + field);
    console.log("With the value: " + value);
    console.log("UiId: " + getUiId(field));
    await editTextField(driver, getUiId(field), value);

});

When("I select the {string} course", async function (course:string) {
    await waitForElement(driver, UiId.courseDropdownField);
    await clickButton(driver, UiId.courseDropdownField);
    await waitForElementByValue(driver, course);
    await clickDropdownItemByValue(driver, course);
});

When("I set the group type as {string}", async function (groupType: string) {
    if (groupType === "public") {
        await clickButton(driver, UiId.isPrivateGroupSwitch);
    }
});

When("I click the create button", async function () {
    // scroll
    driver.execute("flutter:scrollUntilVisible", byType("SingleChildScrollView"), {
        item: byValueKey(UiId.createGroupButton),
        dyScroll: -400,
    });

    await clickButton(driver, UiId.createGroupButton);
});


Then("The system creates the group successfully and displays a confirmation message",
    async function () {
        await waitForElement(driver, UiId.successSnackbar);
        const actualMessage = await getText(driver, UiId.successSnackbar);

        const expectedMessage = "The group created successfully.";
        assert.strictEqual(actualMessage, expectedMessage, "The success message did not match");
    }
);

When(
    "The student attempts to create a group without filling in one or more required fields",
    async function () {
        driver.execute("flutter:scrollUntilVisible", byType("SingleChildScrollView"), {
            item: byValueKey(UiId.createGroupButton),
            dyScroll: -400,
        });
    
        await clickButton(driver, UiId.createGroupButton);
    }
);

Then(
    "The system displays an error message prompting the student to complete all required fields",
    async function () {
        await waitForElement(driver, UiId.errorSnackbar);
        const actualMessage = await getText(driver, UiId.errorSnackbar);

        const expectedMessage = "Failed to create group.";
        assert.strictEqual(actualMessage, expectedMessage, "The error message did not match");
    }
);

Given("A telegram account has not been linked", async function () {});

When("The student goes on the group creation page", async function () {});

Then("An error message appears to ask the user to link a Telegram account", async function () {});
