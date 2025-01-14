from faker import Faker
import yaml
import random

faker = Faker()


# - id: 10
#       first_name: Noah
#       last_name: White
#       email: S4919418.@studenti.unige.it
#       password: 10
#       courses:
#           - AUGMENTED REALITY


# Define courses (magistrale)
courses = [
    "DIGITAL SIGNAL & IMAGE PROCESSING", "DISTRIBUTED COMPUTING", "MACHINE LEARNING",
    "AUGMENTED REALITY", "COMPUTATIONAL VISION", "DEEP LEARNING",
    "ADDITIONAL USEFUL KNOWLEDGE", "COMPUTATIONAL NEUROENGINEERING",
    "COMPUTER GRAPHICS", "CAPSTONE", "TOPICS IN COMPUTER SCIENCE", "DATA WAREHOUSING",
    "INTERNET OF THINGS", "NETWORK ANALYSIS", "PREDICTIVE ANALYTICS PROJECT",
    "SOFTWARE ENGINEERING FOR DATA ANALYTICS", "HUMAN COMPUTER INTERACTION",
    "MACHINE LEARNING AND DATA ANALYSIS", "SOFTWARE SYSTEMS DESIGN AND MODELLING",
    "VIRTUALIZATION AND CLOUD COMPUTING", "FUNCTIONAL AND SECURITY TESTING TECHNIQUES",
    "IT PROJECT MANAGEMENT", "MOBILE DEVELOPMENT", "DATA PROTECTION & PRIVACY",
    "DIGITAL FORENSICS", "PRINCIPLES AND PARADIGMS OF PROGRAMMING LANGUAGES",
    "DATA VISUALIZATION", "HIGH PERFORMANCE COMPUTING", "MULTIAGENT SYSTEMS",
    "NATURAL LANGUAGE PROCESSING", "COMPUTER GAMES", "GEOMETRIC MODELING",
    "TRUSTWORTHY ARTIFICIAL INTELLIGENCE", "ADVANCED DATA MANAGEMENT", "FINAL DISSERTATION"
]

# Generate students
students = []
for _ in range(100):
    student_id = random.randint(4000000, 4999999)
    first_name = faker.first_name()
    last_name = faker.last_name()

    gpa = random.gauss(23.5, 5)
    if gpa < 18:
        gpa = 18
    if gpa > 30:
        gpa = 30

    gpa = int(round(gpa, 0))

    student_study_plan = random.sample(courses, k=15)

    student_exams_to_take = random.sample(
        # if you have 0 exam to take? we need to check this?
        student_study_plan, k=random.randint(1, 15))

    n_max_courses_semester = len(
        student_exams_to_take) if len(student_exams_to_take) < 6 else 6

    student_courses_semester = random.sample(
        # this semester courses you need to pass
        student_exams_to_take, k=random.randint(1, n_max_courses_semester))
    password = faker.password(
        length=6, special_chars=False, digits=True, upper_case=True, lower_case=True)

    students.append({
        "id": student_id,
        "first_name": first_name,
        "last_name": last_name,
        "email": f"S{student_id}.@studenti.unige.it",
        "password": password,
        "gpa": gpa,
        "study_plan": student_study_plan,
        "exams_to_take": student_exams_to_take,
        "courses": student_courses_semester,
    })


# Save to YAML
students_file_path = 'data.yml'
with open(students_file_path, 'w') as file:
    yaml.dump({"courses": courses}, file, sort_keys=False)
    yaml.dump({"students": students}, file, sort_keys=False)
