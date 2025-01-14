import { getEnvironmentVariable } from "../utils/config_error";

export const JWT_SECRET = getEnvironmentVariable("JWT_SECRET");
