import StudentService from '../service/student_service';

export async function getProfileService(studentId) {
    try {
        const response = await fetch(`http://unigeapi:8000/student/${studentId}`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJzdHVkeV9idWRzIn0.RuHH3N-8d0sxukvyVCuq59xnWf-vhkgPmnU30pv1Yo0`, // Add the token here
            },
        });

        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }

        const data = await response.json();
        
        // Remove the 'courses' field
        const { courses, ...dataWithoutCourses } = data;

        console.log(studentId);
        
        const response2 = await StudentService.getStudentById(studentId);

        // Check if response2 is null or undefined
        if (!response2) {
            throw new Error('StudentService.getStudentById returned null or undefined');
        }

        if (!response2) {
            throw new Error(`Student object of getProfileService`);
        }

        dataWithoutCourses['telegram_account'] = response2['dataValues']['telegramAccount'];

        return dataWithoutCourses;
    } catch (error) {
        console.error('Error fetching profile:', error);
        throw error;
    }
}
