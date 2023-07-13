-- ALTER: The ALTER statement is used to modify the structure of an existing table in MySQL. In this example, we use ALTER to add a new column (column_name) to the table and designate it as the primary key.
-- ALTER TABLE table_name
-- ADD column_name INT PRIMARY KEY;
-- The ADD keyword specifies that we are adding a new column, and INT defines the data type of the column. We also include PRIMARY KEY to specify that this column will be the primary key for the table.

-- MODIFY: The MODIFY clause is used in conjunction with ALTER to modify the properties of an existing column. In this example, we use MODIFY to enable the auto-increment property for the newly added column.
-- ALTER TABLE table_name
-- MODIFY column_name INT AUTO_INCREMENT;
-- the MODIFY clause in SQL is used within the ALTER TABLE statement to modify the attributes of an existing column in a table. It doesn't support a WHERE clause directly.



-- create database c361cohort;
use c361cohort;
create table employee(
employee_id int primary key,
emp_name varchar(200));
select * from employee;
insert into employee values(1,'john');
insert into employee values(2,'john');
select * from employee;
drop table employee;

-- auto increment of id primary key
create table employee1(id int primary key auto_increment,first_name text);
select * from employee1;
insert into employee1(first_name) values('cnjcndcwwc');

-- alter table employee1 alter column id set default 100;
select * from employee1;

create table emp2(id int not null , lname text );

select * from emp2;
insert into emp2 values(1, 'sdasd');
select * from emp2;
alter table emp2 modify id int primary key auto_increment;
insert into emp2(lname) values('evjknvjern');



create table new(id int primary key , city text);
select * from new;
insert into new values(12,'lol');
alter table new modify id int primary key ;
insert into new(city) values('kooolllll');
alter table new modify column id int;
alter table new drop column id;
alter table new add id int auto_increment primary key;
ALTER TABLE new AUTO_INCREMENT = 10;

create table onemore(id int primary key, city text); -- created a table
insert into onemore values(1,'hell'); -- inserted values
select * from onemore; 
-- return the table
ALTER TABLE onemore MODIFY id INT AUTO_INCREMENT; -- modifying the table, adding auto_increment feature to id
ALTER TABLE onemore AUTO_INCREMENT = 10; -- set fthe value to 10 off auto increment
insert into onemore(city) values('lll'); -- inserting
ALTER TABLE onemore ALTER COLUMN id SET DEFAULT 15; -- set default feature of id 

select * from onemore where id=1;
select * from onemore where city like '%ll%' ;
update onemore set city='yaha' where id=1;

set  SQL_SAFE_UPDATES = 1; -- 0 :- disabled safe update 1: enables
update onemore set city='yaha';
-- update onemore set city='yaha' , if we want to use it like this without where, 

-- " ALTER TABLE temp_table RENAME TO original_table " is used in SQL to rename a table. It allows you to change the name of an existing table to a new name.
-- " alter table onemore rename column city to name- used fopr changing column name
delete from onemore where id=1;
alter table onemore rename column city to name;

DESCRIBE ONEMORE;

TRUNCATE ONEMORE;

create table student1 (
id int primary key,
name varchar(100) not null,
gender ENUM('M','F','T'));
-- gender char(1) character set ascii ); -- gender  enum('M','f','t')
select * from student1;

insert into student1 values(1,'hi','N');

select user from mysql.user;
-- user creation
create user xyxy identified by 'pass';
grant all privileges on *.* to xyxy;

show grants for xyxy;

select user, host, account_locked, password_Expired from mysql.user;
select user, host , db, command from information_schema.processlist;
select * from mysql.user;