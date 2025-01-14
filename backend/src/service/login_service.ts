import jwt from "jsonwebtoken";
import { JWT_SECRET } from "../config/jwt";

export function generateToken(user:{uid:number}){
    return jwt.sign({ user }, JWT_SECRET, { expiresIn: "1y" });
}
