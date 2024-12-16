CREATE SCHEMA IF NOT EXISTS studybuds;
set search_path to studybuds;

CREATE TABLE student (
    student_id int PRIMARY KEY,
    telegram_account int
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE student_group (
    id serial PRIMARY KEY,
    name varchar(40) NOT NULL,
    description varchar(100),
    members_limit smallint,
    is_public boolean DEFAULT true,
    course varchar(60) NOT NULL,
    telegram_link varchar(100),
    telegram_id integer,
    admin_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    CHECK (members_limit BETWEEN 2 AND 100)
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE group_members (
    student_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    group_id serial NOT NULL REFERENCES student_group(id) ON UPDATE CASCADE,
    PRIMARY KEY(student_id, group_id)
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE join_request (
    id serial PRIMARY KEY,
    group_id int NOT NULL REFERENCES student_group(id) ON UPDATE CASCADE,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    status varchar(20)
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE fb_token (
    id serial PRIMARY KEY,
    token varchar(200) NOT NULL,
    student_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE notification_type AS ENUM ('join_request', 'accept', 'reject');

CREATE TABLE notification (
    id serial PRIMARY KEY,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    join_request_id integer NOT NULL REFERENCES join_request(id) ON UPDATE CASCADE,
    notification_type notification_type NOT NULL,
    message varchar(50) NOT NULL
    -- ,
    -- created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    -- updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);
