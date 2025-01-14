import { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import assert from 'node:assert';
import { BadRequestError, getErrorMessage, UnhautorizedError } from '../utils/api_error';
import { validateInt } from '../utils/validation_error';
import { JWT_SECRET } from '../config/jwt';


export default function authMiddleware(req: Request, res: Response, next: NextFunction){
    const token = req.header('Authorization')?.replace('Bearer ', '');
    if (token === undefined)
        throw new UnhautorizedError('Access Denied');

    try {
        const verified = jwt.verify(token, JWT_SECRET);
        req.user = verified.user;
        next();
    } catch (err) {
        throw new BadRequestError(`Invalid Token: ${getErrorMessage(err)}`);
    }
};

export function getStudentId(req: Request) : number {
    assert (req.user !== undefined);
    assert (req.user.uid !== undefined);
    return validateInt(req.user, "uid");
}

