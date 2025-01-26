import axios from "axios";
import dotenv from "dotenv";

dotenv.config();

const BOT_TOKEN = process.env.TELEGRAM_BOT_TOKEN;
if (!BOT_TOKEN) throw new Error("Telegram Bot Token is not defined in .env file");
const TELEGRAM_API_BASE = `https://api.telegram.org/bot${BOT_TOKEN}`;

export async function isUserInGroup(userId: string, groupId: string): Promise<boolean> {
    try {
        const response = await axios.get(`${TELEGRAM_API_BASE}/getChatMember`, {
            params: { chat_id: groupId, user_id: userId },
        });
        const { status } = response.data.result;
        return ["member", "administrator", "creator"].includes(status);
    } catch (error) {
        console.error("Failed to verify user membership:", error.response?.data || error.message);
        throw new Error("Failed to verify if the user is in the group.");
    }
}

export async function getGroupTitleFromBot(groupId: string): Promise<string> {
    try {
        const response = await axios.get(`${TELEGRAM_API_BASE}/getChat`, {
            params: { chat_id: groupId },
        });
        return response.data.result.title;
    } catch (error) {
        console.error("Failed to get group title:", error.response?.data || error.message);
        throw new Error("Failed to get the group title.");
    }
}
