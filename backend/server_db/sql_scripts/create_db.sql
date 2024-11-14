-- Create the database
CREATE DATABASE studybuds_db;

-- Connect to the newly created database
\c studybuds_db

CREATE TABLE Student (
    student_id int PRIMARY KEY,
    telegram_account int
);

CREATE TABLE StudentsGroup (
    id serial PRIMARY KEY,
    students_group_name varchar(40) NOT NULL,
    students_group_description varchar(100),
    members_limit smallint ,
    is_public boolean DEFAULT true,
    course varchar(60) NOT NULL,
    telegram_link varchar(100),
    telegram_id integer,
    admin_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE
    CHECK (members_limit BETWEEN 2 AND 100)
);

CREATE TABLE StudentsGroupMember (
    student_id smallint NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    students_group_id serial NOT NULL REFERENCES StudentsGroup(id) ON UPDATE CASCADE,
    PRIMARY KEY(student_id, students_group_id)
);

CREATE TABLE JoinRequest (
    join_request_id serial PRIMARY KEY,
    group_id serial NOT NULL REFERENCES StudentsGroup(id) ON UPDATE CASCADE,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    join_request_status varchar(20)
);

CREATE TABLE FbToken (
    fb_token_id serial PRIMARY KEY,
    token varchar(200) NOT NULL,
    student_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE 
);

CREATE TABLE Notification (
    notification_id serial PRIMARY KEY,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    join_request_id bigint NOT NULL REFERENCES JoinRequest(join_request_id) ON UPDATE CASCADE,
    notification_type varchar(20) NOT NULL
);

