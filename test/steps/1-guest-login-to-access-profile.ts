import { byValueKey, byText } from "appium-flutter-finder";
import { BottomBarIcon, go_to_page, UiId } from "./../utils/utils";
import { Given, When, Then, Before } from "@cucumber/cucumber";
import { driver } from "./all";
import { do_logout } from "../utils/utils";
import { initDB } from "../utils/mock-data";
import { Student } from "../../backend/src/models/Student";

// let driver:WebdriverIO.Browser;
// Before(()=>driver=getDriver())


Before({tags: "@guest-login-to-access-profile"},async function () {
    const student1=10;
    await initDB([
        new Student({studentId: student1,telegramAccount:36})
    ])
});


Given("I am on the home page not logged in", async () => {
    const loginPage = byValueKey(UiId.loginPage);
    await driver.execute("flutter:waitFor", loginPage);
});

When("I click on the login button", async () => {
    const loginButton = byValueKey("login_button");
    await driver.elementClick(loginButton);
});

Then("I am logged in successfully", async () => {
    await driver.execute("flutter:waitFor", byValueKey(UiId.joinedGroupTab), 5000);
});

Then("I can see my profile username {string}", async (username: string) => {
    await go_to_page(driver, BottomBarIcon.profile);
    //getText doesnt work on textfields
    //const studentId = byValueKey("student_id_text");
    //await driver.execute('flutter:waitFor', studentId);

    await driver.execute("flutter:waitFor", byText(username));
});

When(
    "I input my Unige credentials username {string} and password {string}",
    async (username: string, password: string) => {
    
            await driver.waitUntil(
                async () => {
                    const contexts = await driver.getContexts();
                    return contexts.includes("WEBVIEW_chrome");
                },
                { timeout: 10_000, timeoutMsg: "WEBVIEW_chrome context not found" }
            );

            await driver.switchContext("WEBVIEW_chrome");
            driver.$('//input[@id="username"]').waitForDisplayed({ timeout: 10_000 });

            await Promise.all([
                driver.$('//input[@id="username"]').setValue(username),
                driver.$('//input[@id="password"]').setValue(password),
            ]);
            const button = await driver.$('//button[contains(text(), "Login")]');

            //await driver.$('//input[@id="password"]').addValue("\uE007");

            //await button.waitForEnabled()
            await button.click();

            await driver.waitUntil(
                async () => {
                    const contexts = await driver.getContexts();
                    return contexts.includes("FLUTTER");
                },
                { timeout: 10_000, timeoutMsg: "FLUTTER context not found" }
            );

            await driver.switchContext("FLUTTER");
        
    }
);

Then("I do the logout", async () => {
    await do_logout(driver);
});
