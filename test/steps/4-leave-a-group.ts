import { Given, Then, When } from "@cucumber/cucumber";
import assert from "assert";
import { getGroupTitleFromBot, isUserInGroup } from "../utils/telegram-bot";
import { driver } from "./all";

Given(
    "I with Telegram id {string} am on Telegram in the group with telegram id {string}",
    async function (userTelegramId: string, groupTelegramId: string) {
        const isInGroup = await isUserInGroup(userTelegramId, groupTelegramId);
        assert.strictEqual(
            isInGroup,
            true,
            `User with ID ${userTelegramId} is not in the group with ID ${groupTelegramId}`
        );
    }
);

When(
    "The student leaves the group with telegram id {string} in Telegram",
    async function (groupTelegramId: string) {
        const groupTitle = await getGroupTitleFromBot(groupTelegramId);

        // Open Telegram and perform actions
        await driver.switchContext("NATIVE_APP");
        await driver.execute("mobile: shell", {
            command: "am start -n org.telegram.messenger/org.telegram.ui.LaunchActivity",
        });
        await driver.pause(2000);

        // Search for the group
        const searchButton = await driver.$("~Search");
        await searchButton.click();

        const searchBar = await driver.$('//android.widget.EditText[@text="Search"]');
        await searchBar.setValue(groupTitle);

        const groupResult = await driver.$(`//android.view.ViewGroup[starts-with(@text, "${groupTitle},")]`);
        await groupResult.waitForDisplayed({ timeout: 5000 });
        await groupResult.click();

        const optionsButton = await driver.$("~More options");
        await optionsButton.click();

        const leaveGroupButton = await driver.$('//android.widget.TextView[@text="Leave group"]');
        await leaveGroupButton.click();

        const confirmLeaveButton = await driver.$('(//android.widget.TextView[@text="Leave group"])[2]');
        await confirmLeaveButton.click();

        // Reopen your app
        await driver.execute("mobile: shell", {
            command: "am start -n com.orange.mobile_app/com.orange.mobile_app.MainActivity",
        });
        await driver.pause(2000);
        await driver.switchContext("FLUTTER");
    }
);

Then(
    "The student with id {string} is removed from the group with id {string}",
    async function (userTelegramId: string, groupTelegramId: string) {
        const isInGroup = await isUserInGroup(userTelegramId, groupTelegramId);
        assert.strictEqual(
            isInGroup,
            false,
            `User with ID ${userTelegramId} is still in the group with ID ${groupTelegramId}`
        );
    }
);
