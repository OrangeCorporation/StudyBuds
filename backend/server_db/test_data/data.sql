set search_path to studybuds;

-- Api testing: get joined group list

insert into student (student_id,telegram_account) values (4071780,33);
insert into student (student_id,telegram_account) values (4669615,34);

insert into student_group (id,name, description, course,admin_id, members_limit, gpa) values (100,'CP','description','Capstone',4071780, 10, 26);
insert into student_group (id,name, description, course,admin_id, members_limit,is_public, gpa) values (101,'CP2', 'description','Capstone',4669615, 10,false, 24);

insert into group_members (student_id,group_id) values (4071780,100);
insert into group_members (student_id,group_id) values (4669615,100);

insert into group_members (student_id,group_id) values (4071780,101);
insert into group_members (student_id,group_id) values (4669615,101);

-- Acceptance testing: basic group search

insert into student (student_id,telegram_account) values (10,36);
insert into student_group (id,name, description, course,admin_id,members_limit,is_public, gpa) values (102,'adm','test description','Capstone',10,10,false, 18);
insert into group_members (student_id,group_id) values (10,102);


-- Manage join requests

-- insert into student (student_id,telegram_account) values (10,35);
insert into student (student_id,telegram_account) values (12,37);

insert into student_group (id,name, description,course,admin_id,members_limit, gpa) values (103,'joinrequest', 'description','Capstone',10,100, 18);
insert into group_members (student_id,group_id) values (10,103);

insert into join_request (id,group_id,student_id,status) values (11,103,12,'pending');
insert into notification (student_id,join_request_id,notification_type,message) values (10,11,'join_request','Nona has requested to join the Capstone project');

insert into join_request (id,group_id,student_id,status) values (12,103,12,'pending');
insert into notification (student_id,join_request_id,notification_type,message) values (10,12,'join_request','Nona has requested to join the Capstone project');


-- Joined group list

insert into student (student_id,telegram_account) values (42674,1435);
insert into student (student_id,telegram_account) values (42675,1436);

insert into student_group (id,name, description, course,admin_id,gpa) values (104,'mygroupyes','description','Capstone',42674, 20);
insert into group_members (student_id, group_id) values (42674,104);

insert into student_group (id,name,description, course,admin_id,members_limit, gpa) values (105,'groupof10','description','Capstone',10,100, 18);
insert into group_members (student_id,group_id) values (42674,105);
insert into group_members (student_id,group_id) values (10,105);

-- demo

insert into group_members (student_id,group_id) values (10,104);



-- Join request Acceptance testing

insert into student (student_id,telegram_account) values (11,4848);

insert into student_group (id,name, members_limit, is_public, course,admin_id, gpa) values (7,'aya',10, false, 'Capstone', 11, 29);



insert into join_request (id,group_id,student_id,status) values (13,7,10,'pending');


--- Test getSuggestedGroupsbyFriends function
insert into group_members (student_id,group_id) values (11,105);
