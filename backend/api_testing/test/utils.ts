import axios from "axios";
import { generateToken } from "../../src/service/login_service";

export const BACKEND_URL=process.env["BACKEND_URL"];
export const axios_instance = axios.create({
  validateStatus: (status) => status === 200,
});

export function getToken(user:number):string{
    return generateToken({uid:user});
}
