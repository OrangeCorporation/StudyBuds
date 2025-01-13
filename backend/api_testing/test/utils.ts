import axios from "axios";

export const BACKEND_URL=process.env["BACKEND_URL"];
export const axios_instance = axios.create({
  validateStatus: (status) => status === 200,
});
