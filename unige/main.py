from typing import Annotated
from os import environ
from yaml import safe_load
from fastapi import Depends, FastAPI, HTTPException, status
from dataclasses import dataclass
from pydantic import TypeAdapter
from pathlib import Path
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
import jwt

app = FastAPI(root_path="/api")

SECRET_KEY = environ.get("SECRET_KEY", "changeme")
ALGORITHM = "HS256"

token_scheme = HTTPBearer()


@dataclass
class Student:
    id: int
    first_name: str
    last_name: str
    gpa: int
    study_plan: list[str]
    exams_to_take: list[str]
    courses: list[str]


@dataclass
class Database:
    students: list[Student]
    courses: list[str]


DATABASE = TypeAdapter(Database).validate_python(
    safe_load(Path(environ.get("DATABASE", "data.yml")).read_text())
)


def print_token():
    print(jwt.encode({"sub": "study_buds"}, SECRET_KEY,
          algorithm=ALGORITHM))  # type: ignore


def validate_token(
    token: Annotated[HTTPAuthorizationCredentials, Depends(token_scheme)],
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token.credentials, SECRET_KEY,
                             algorithms=[ALGORITHM])  # type: ignore
        username: str = payload.get("sub")
        if username != "study_buds":
            raise credentials_exception
    except jwt.InvalidTokenError:
        raise credentials_exception


@app.get("/student/{student_id}", dependencies=[Depends(validate_token)])
def get_student(student_id: int):
    """Get the details of a student"""
    for student in DATABASE.students:
        if student.id == student_id:
            return student
    raise HTTPException(status.HTTP_404_NOT_FOUND)


@app.post("/students/gpa", dependencies=[Depends(validate_token)])
def calculate_average_gpa(student_list: list[int]):
    """Calculate the average GPA of a list of students"""
    total_gpa = 0
    count = 0
    for student in DATABASE.students:
        if student.id in student_list:
            total_gpa += student.gpa
            count += 1
    if count == 0:
        raise HTTPException(status.HTTP_404_NOT_FOUND,
                            detail="No students found")
    return {"average_gpa": total_gpa / count}


@app.post("/students", dependencies=[Depends(validate_token)])
def get_students(student_list: list[int]):
    """Get the details of students"""
    return [
        {
            "first_name": student.first_name,
            "last_name": student.last_name,
            "id": student.id,
        }
        for student in DATABASE.students
        if student.id in student_list
    ]


@app.get("/courses", dependencies=[Depends(validate_token)])
def get_courses():
    """List all the courses available in the university"""
    return DATABASE.courses


if __name__ == "__main__":
    print_token()
