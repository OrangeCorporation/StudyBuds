import { byText, byValueKey } from "appium-flutter-finder";
import {driver} from "../steps/all.ts";
import { exec } from "child_process";

export enum BottomBarIcon {
    search = "icon_search",
    add = "icon_add",
    notifications = "icon_notifications",
    profile = "icon_profile",
    home = "icon_home",
}

const pageNameToIconMap: { [key: string]: BottomBarIcon } = {
    profile: BottomBarIcon.profile,
    search: BottomBarIcon.search,
    "group creation": BottomBarIcon.add,
    notifications: BottomBarIcon.notifications,
    home: BottomBarIcon.home,
};


export function getBottomBarIcon(pageName: string): BottomBarIcon {
    return pageNameToIconMap[pageName];
}

export enum UiId {
    telegramAccountIdTextField = "telegram_account_id_text_field",
    fullNameTextField = "full_name_text_field",
    studentIdTextField = "student_id_text_field",
    loginPage = "login_page",
    groupNameTextField = "group_name_field",
    groupDescriptionTextField = "group_description_field",
    membersLimitTextField = "members_limit_field",
    telegramGroupLinkTextField = "telegram_group_link_field",
    isPrivateGroupSwitch = "is_private_group_switch",
    createGroupButton = "create_group_button",
    successSnackbar = "success_snackbar",
    errorSnackbar = "error_snackbar",
    courseDropdownField = "course_dropdown_field",
    groupDetailsName = "group_details_name",
    groupDetailsMembersCount = "group_details_members_count",
    groupDetailsCloseButton = "group_details_close_button",
    groupDetailsTypeIcon = "group_details_type_icon",
    groupDetailsDescription = "group_details_description",
    groupDetailsCourse = "group_details_course",
    joinedGroupTab = "joined_groups_tab",
    ownedGroupTab = "owned_groups_tab",
    logoutButton = "logout_button",
    logoutConfirmationDialog = "logout_confirmation_dialog",
    confirmLogout = "confirm_logout",
    guestButton = "guest_button",
    loginButton = "login_button",
    searchBar = "search_bar",
    searchButton = "search_button",
    noResultsMessage = "no_results_message",
    sendJoinRequestButton = "send_join_request_button"
}

const fieldNameToUiIdMap: { [key: string]: UiId } = {
    "group name": UiId.groupNameTextField,
    "description": UiId.groupDescriptionTextField,
    "member limit": UiId.membersLimitTextField,
    "telegram group link": UiId.telegramGroupLinkTextField,
    "telegramId": UiId.telegramAccountIdTextField,
    "group details name": UiId.groupDetailsName,
    "group details members count": UiId.groupDetailsMembersCount,
    "group details type icon": UiId.groupDetailsTypeIcon,
    "group details description": UiId.groupDetailsDescription,
    "group details course": UiId.groupDetailsCourse,
    "Joined group": UiId.joinedGroupTab,
    "Owned group": UiId.ownedGroupTab,
};

export function getUiId(fieldName: string): UiId {
    return fieldNameToUiIdMap[fieldName];
}

// Function to map ordinal numbers to their corresponding numeric values
export function ordinalToNumber(ordinal: string): number {
    const ordinals: { [key: string]: number } = {
        first: 1,
        second: 2,
        third: 3,
        fourth: 4,
        fifth: 5,
        // Add more mappings as needed
    };

    return ordinals[ordinal.toLowerCase()] || 0; // Return 0 if the ordinal is not found
}

type Key = string | number;
type Value = string;

export async function go_to_page(driver: WebdriverIO.Browser, bottom_bar_icon: BottomBarIcon) {
    await clickButton(driver, bottom_bar_icon);
}

export async function clickButton(driver: WebdriverIO.Browser, key: Key) {
    const btn = byValueKey(key);
    await driver.elementClick(btn);
}

export async function getText(driver: WebdriverIO.Browser, key: Key) {
    const textField = byValueKey(key);
    return await driver.getElementText(textField);
}

export function sleep(seconds: number) {
    return new Promise((resolve) => setTimeout(resolve, seconds * 1000));
}

export async function waitForElement(driver: WebdriverIO.Browser, key: Key) {
    const element = byValueKey(key);
    await driver.execute("flutter:waitFor", element);
}

export async function login(driver: WebdriverIO.Browser, username: string, password: string) {
    // Switch to the WebView context
    console.log("Getting available contexts...");
    let webContext: string | undefined;
    for (let attempt = 1; attempt <= 5; attempt++) {
        const contexts = await driver.getContexts(); // Returns an array of contexts
        console.log(`Available contexts (attempt ${attempt}):`, contexts);

        webContext = contexts.find(
            (context) => typeof context === "string" && context.includes("WEBVIEW")
        ) as string | undefined; // Cast context to string | undefined

        if (webContext) break; // Exit loop if WebView context is found
        await driver.pause(1000); // Wait for 1 second before retrying
    }

    if (!webContext) {
        throw new Error("No web context found after multiple attempts.");
    }

    console.log("Switching to web context:", webContext);
    await driver.switchContext(webContext);

    // Fill in login form and submit
    console.log("Locating web page elements...");
    const [usernameField, passwordField, submitButton] = await Promise.all([
        driver.$('input[name="username"]'),
        driver.$('input[name="password"]'),
        driver.$("button"),
    ]);

    console.log("Filling username and password fields...");
    await Promise.all([
        usernameField.setValue(username),
        passwordField.setValue(password),
    ]);

    console.log("Clicking submit button...");
    await submitButton.click();

    // Switch back to Flutter context
    console.log("Waiting for the webview to close...");
    await driver.pause(5000); // Wait for the app to return to Flutter context

    console.log("Switching back to FLUTTER context...");
    await driver.switchContext("FLUTTER");
}

export async function waitForElementByValue(driver: WebdriverIO.Browser, value: Value) {
    await driver.execute("flutter:waitFor", byText(value));
}

export async function editTextField(driver: WebdriverIO.Browser, key: Key, value: Value) {
    const textField = byValueKey(key);
    await driver.elementSendKeys(textField, value);
}

export async function clickDropdownItemByValue(driver: WebdriverIO.Browser, value: string) {
    const item = byText(value);
    await driver.elementClick(item);
}

export async function do_logout(driver: WebdriverIO.Browser) {
    const logout_button = byValueKey(UiId.logoutButton);
    await driver.elementClick(logout_button);
    const logout_confirmation_dialog = byValueKey(UiId.logoutConfirmationDialog);
    await driver.execute("flutter:waitFor", logout_confirmation_dialog);
    const confirm_logout = byValueKey(UiId.confirmLogout);
    await driver.elementClick(confirm_logout);
    await clearChromeCacheFlutterCompatible();
}
/**
 * Clears the cache and data for the Chrome browser on the connected Android device.
 */

export async function clearChromeCacheFlutterCompatible() {
    console.log("Clearing Chrome cache using ADB (Flutter-Compatible)...");
    await driver.switchContext("NATIVE_APP")
    await driver.executeScript("mobile: shell",[{"command":"am kill com.android.chrome"}]);
    await driver.switchContext("FLUTTER")
}
