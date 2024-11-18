import { getStudentFirebaseToken, saveFbToken, updateFbToken } from '../service/firebase_token_service';

export const saveToken = async (req, res) => {
    try {
        const { studentId, token } = req.body;

        const fbTokenModel = await getStudentFirebaseToken(studentId);

        if (!fbTokenModel) {
            await saveFbToken(studentId, token);
            return res.status(200).send({ message: "Successfully saved the student's Firebase token" });
        } else {
            await updateFbToken(studentId, token);
            return res.status(200).send({ message: "Successfully updated the student's Firebase token" });
        }
    } catch (err) {
        console.error('Error in saveToken:', err);
        return res.status(err.status || 500).send(err.message || 'Internal server error');
    }
};

