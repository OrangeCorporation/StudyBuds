import { Given, When, Then } from "@cucumber/cucumber";
import { driver } from "./all";
import { byValueKey } from "appium-flutter-finder";
import {
    BottomBarIcon,
    go_to_page,
    waitForElementByValue,
    clearChromeCacheFlutterCompatible,
    UiId
} from "../utils/utils.ts";


Given("I am on the profile page", async function () {
    await go_to_page(driver, BottomBarIcon.profile);
});

When("I click on the logout button", async function () {
    const logout_button = byValueKey(UiId.logoutButton);
    await driver.elementClick(logout_button);
});

Then("A confirmation dialog should appear", async function () {
    const logout_confirmation_dialog = byValueKey(UiId.logoutConfirmationDialog);
    await driver.execute("flutter:waitFor", logout_confirmation_dialog);
});

When("I click on the confirm button", async function () {
    const confirm_logout = byValueKey(UiId.confirmLogout);
    await driver.elementClick(confirm_logout);
});

Then("I should be logged out and be redirected to the login screen", async function () {
    await clearChromeCacheFlutterCompatible();

    await waitForElementByValue(driver, 'Continue as a guest');

});
