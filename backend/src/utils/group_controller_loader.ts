// Importing types from Express for handler signatures
import { Request, Response } from "express";

// Define the shape of the GroupController module
export interface GroupController {
    basicSearchResult: (req: Request, res: Response) => void;
    createGroup: (req: Request, res: Response) => void;
    getAllGroups: (req: Request, res: Response) => void;
}

