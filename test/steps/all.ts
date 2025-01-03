import { After, Before, setDefaultTimeout } from "@cucumber/cucumber";
import { remote } from "webdriverio";

//DOCS:

//webdriverio            https://webdriver.io/docs/selectors
//native/webapp          https://github.com/appium/appium-uiautomator2-driver
//flutter-driver         https://github.com/appium/appium-flutter-driver

const osSpecificOps: any = {
  platformName: "Android",
  "appium:app":
    process.env.APPIUM_APK ||
    "../mobile_app/build/app/outputs/flutter-apk/app-debug.apk",
};
if (
  process.env.APPIUM_CHROMEDRIVER_PATH &&
  process.env.APPIUM_CHROMEDRIVER_PATH !== "disabled"
) {
  osSpecificOps["appium:chromedriverExecutable"] =
    process.env.APPIUM_CHROMEDRIVER_PATH;
}
if (process.env.APPIUM_DEVICE && process.env.APPIUM_DEVICE !== "disabled") {
  osSpecificOps["appium:deviceName"] = process.env.APPIUM_DEVICE;
}

const opts = {
  hostname: process.env.APPIUM_HOST ? process.env.APPIUM_HOST : "127.0.0.1",
  port: Number.parseInt(
    process.env.APPIUM_PORT ? process.env.APPIUM_PORT : "4723",
  ),
  path: "/",
  capabilities: {
    ...osSpecificOps,
    "appium:automationName": "Flutter",
    "appium:chromedriverAutodownload": true, // Enables automatic ChromeDriver download
    "appium:autoGrantPermissions": true, // Automatically grant app permissions
    "appium:webviewConnectRetries": 10, // Retries for WebView connection
    "appium:enableWebviewDetailsCollection": true, // Collect WebView details
    "appium:ensureWebviewsHavePages": true, // Ensures WebView has pages before switching
  },
};

const SECONDS_TIMEOUT = 30_000; // 30 seconds

export let driver: WebdriverIO.Browser;
setDefaultTimeout(SECONDS_TIMEOUT);

Before(async function () {
  driver = await remote(opts);
  driver.implicitWait(5_000);
  await driver.switchContext("FLUTTER");
});

After(async function () {
  if (driver) {
    // do_logout();
    await driver.deleteSession();
  }
});

export function getDriver() {
  return driver;
}
