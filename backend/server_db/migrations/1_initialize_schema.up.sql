BEGIN;

CREATE SCHEMA IF NOT EXISTS studybuds;
set search_path to studybuds;

create type notification_type as enum ('join_request','accept','reject');

CREATE TABLE IF NOT EXISTS student (
    student_id int PRIMARY KEY,
    telegram_account int,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS student_group (
    id serial PRIMARY KEY,
    name varchar(40) NOT NULL,
    description varchar(100),
    members_limit smallint,
    is_public boolean DEFAULT true,
    gpa numeric(4, 2) NOT NULL,
    course varchar(60) NOT NULL,
    telegram_link varchar(100),
    telegram_id integer,
    admin_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    CHECK (members_limit BETWEEN 2 AND 100),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS group_members (
    student_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    group_id int NOT NULL REFERENCES student_group(id) ON UPDATE CASCADE,
    PRIMARY KEY(student_id, group_id),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS join_request (
    id serial PRIMARY KEY,
    group_id integer NOT NULL REFERENCES student_group(id) ON UPDATE CASCADE,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    status varchar(20),
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS fb_token (
    id serial PRIMARY KEY,
    token varchar(200) NOT NULL,
    student_id int NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notification (
    id serial PRIMARY KEY,
    student_id integer NOT NULL REFERENCES Student(student_id) ON UPDATE CASCADE,
    join_request_id integer NOT NULL REFERENCES join_request(id) ON UPDATE CASCADE,
    notification_type notification_type NOT NULL,
    message varchar(50) NOT NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP
);


CREATE MATERIALIZED VIEW IF NOT EXISTS group_popularity
AS
  SELECT group_id, COUNT(*) as members FROM group_members GROUP BY group_id ORDER BY members DESC;


REFRESH MATERIALIZED VIEW group_popularity;

COMMIT;
