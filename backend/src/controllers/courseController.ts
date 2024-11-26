import { Request, Response } from 'express';
import axios from 'axios';
import { exec } from 'child_process';

export const getCourses = async (req: Request, res: Response): Promise<void> => {
    try {
        // Step 1: Dynamically generate the token
        const token = await new Promise<string>((resolve, reject) => {
            resolve(process.env.UNIGE_TOKEN!)
        });

        // Step 2: Fetch courses from the external API using the token
        const response = await axios.get('http://unigeapi:8000/courses', {
            headers: {
                Authorization: `Bearer ${token}`,
            },
        });

        const courses = response.data;

        res.status(200).json({
            courses,
        });
    } catch (error) {
        console.error('Error fetching courses:', error);

        res.status(500).json({
            message: 'Failed to fetch courses',
            error: error.response ? error.response.data : error.message,
        });
    }
};
