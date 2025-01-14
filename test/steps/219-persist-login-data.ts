import { Given, When, Then } from "@cucumber/cucumber";
import { byValueKey } from "appium-flutter-finder";
import assert from "assert";
import {
    BottomBarIcon,
    do_logout,
    go_to_page, login, UiId, waitForElement
} from "../utils/utils";
import { driver } from "./all";


When("I {string} the application", async function (command:string) {
    if(command === "close") {
        console.log("Start to terminate");
        await driver.terminateApp("com.orange.mobile_app");
        console.log("Application has been terminated");
    } else if(command === "open") {
        console.log("Start to open");
        await driver.activateApp("com.orange.mobile_app");
        console.log("Application has been activated");
    }else{
        console.log("Invalid command");
    }
});

Given("I do the login as {string} {string}", async function (username: string, password: string) {
    const loginPage = byValueKey(UiId.loginPage);
    await driver.execute("flutter:waitFor", loginPage);
    const loginButton = byValueKey(UiId.loginButton);
    await driver.elementClick(loginButton);
    await login(driver, username, password);
});


Then("The login screen is skipped", async function () {
    let loginScreenIsPresent = false;

    try {
        // If flutter:waitFor doesn't throw, it means the guest_button is present
        await driver.execute("flutter:waitFor", byValueKey(UiId.guestButton), 3000);
        loginScreenIsPresent = true;
    } catch (err) {
        console.log(err);
        // If we get here, it means guest_button never appeared within 5 seconds
        // which is what we want (i.e. "skipped")
    }

    assert.ok(!loginScreenIsPresent, "Login screen should be skipped, but it is displayed");
    console.log("Verified that the login screen is skipped");
});

Then("I am on the joined groups screen", async function () {
    try {
        // Wait up to 5 seconds for the "joined_groups_tab" to appear
        await driver.execute("flutter:waitFor", byValueKey(UiId.joinedGroupTab), 5000);

        // If waitFor did not time out, then "joined_groups_tab" is present
        console.log("Verified that 'joined_groups_tab' is visible. We are on the joined groups screen.");
    } catch (err) {
        // If an error or timeout occurs, fail the test explicitly
        console.error("Could not find 'joined_groups_tab'.", err);
        assert.fail("Not on the joined groups screen (joined_groups_tab not found).");
    }
});

