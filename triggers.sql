-- ======= Triggers ==============

create table employeetrigger(id int auto_increment primary key,
 last_name varchar(255) not null);
 
 insert into employeetrigger(last_name) values('sdkjahdaskjd');
 update employeetrigger set last_name='ranawat' where id =1;
 
 select * from employeeaudit;
 select * from employeetrigger;
 
 create table employeeaudit( id int auto_increment primary key,
 last_name varchar(255) not null,
 changedat DATETIME default null,
 action varchar(255) default null);
 
create trigger before_employee_update
	before update on employeetrigger
    for each row
  insert into employeeaudit
  set action = 'update',
  last_name = OLD.last_name,
  changedat=NOW();
  
  
-- ---------------------------------

drop table panda;
create table panda(id int primary key , food varchar(250) default 'Noteaten',
mood varchar(250) default 'unhappy');

create trigger before_panda
	before update on panda
	for each row 
    update panda set mood='happy';
    
update panda set food='eaten' where id = 5;
insert into panda(id) values(5);
select * from panda;

DROP TRIGGER IF EXISTS after_panda;

-- after update not works in same table 
-- DELIMITER $$
-- create trigger after_member_insert1
-- after insert
-- on members for each row
-- begin
-- 	IF NEW.birthdate is NULL then
-- 		update members set birthdate='1900-01-01' where id=NEW.id;
-- 	END IF;
-- END$$
 --     ----------------------------------------------------
 
 
create table members(id int auto_increment,
name varchar(100) not null,
email varchar(255),
birthdate DATE,
primary key(id))  


create table remainders(id int auto_increment, memberId int, message varchar(400) not null,
primary key(id,memberId))

DELIMITER $$
create trigger after_member_insert
after insert
on members for each row
begin
	IF NEW.birthdate is NULL then
		INSERT INTO remainders(memberId,message)
        values(new.id, concat("Hi",new.name,'please update your date of birth'));
	END IF;
END$$


INSERT INTO members(name, email,birthDate)
values('temp1','hsadkjhsd@gmail.com',NULL);
('temp','tegdjksag@gmail.com','2000-01-01');

select * from members;
select * from remainders;

-- ------------------------------------

create table stud(id int auto_increment primary key, name varchar(250), class int);

create table left_students(id int, name varchar(250), class int);

insert into stud(name,class) values('rohan', 8),
('rishabh' , 5),
('goku', 8);

create trigger after_leave
before delete
on stud for each row
INSERT INTO left_students (id, name, class)
VALUES (OLD.id, OLD.name, OLD.class);

delete from stud where id=2;
select * from left_students;

-- -----------------------------------------------------------

create table hospital(id int auto_increment primary key, name varchar(200), exp int, field varchar(200));

insert into hospital(name, exp, field) values('vegeta', 5, 'cardio'),
('goku', 7, 'kidney'),
('bulma' , 6, 'brain');
create table special(name varchar(200), field varchar(200))

DELIMITER $$
create trigger pick_special
after insert on hospital for each row
begin
	if New.exp > 5 then
    insert into special(name, field) values(new.name, new.field);
    end if;
end$$

select * from special;

-- --------------------- using trigger with stored procedure where it contains the union ----

CREATE TABLE temp1 (
  id INT PRIMARY KEY,
  name VARCHAR(250)
);

CREATE TABLE temp2 (
  id INT PRIMARY KEY,
  name VARCHAR(250)
);

create table merged_table(id int, name varchar(250));

DELIMITER $$

CREATE PROCEDURE union_trigger()
BEGIN
  INSERT INTO merged_table (id, name)
  SELECT id, name FROM temp1
  UNION
  SELECT id, name FROM temp2;
END $$

DELIMITER ;

CREATE TRIGGER after_insert_trigger
AFTER INSERT ON temp1
FOR EACH ROW
CALL union_trigger();

-- Insert data into table1
INSERT INTO temp1 (id, name)
VALUES (4, 'John'),
       (5, 'Alice'),
       (6, 'Michael');

-- Insert data into table2
INSERT INTO temp2 (id, name)
VALUES (1, 'Emily'),
       (2, 'Jacob'),
       (3, 'Sophia');

select * from merged_table;
drop table temp2 ;


-- ----------------------------------------------------------------
-- creating errors and adding check in create table

create table sales2(id int auto_increment,
product varchar(400) not null,
quantity int not null default 0,
fiscialyear smallint not null,
fiscalmonth smallint not null,
check(fiscalmonth>=1 and fiscalmonth<=12),
check(fiscialyear between 2001 and 2040),
check(quantity>=0),
unique(product,fiscalmonth,fiscialyear),
primary key(id));

insert into sales2(product, quantity,fiscialyear,fiscalmonth)
values
('Halry davisdson bike 2007',120,2009,1),
('Splendor',500,2022,6),
('kasdhsjakd',120,2009,12);

select * from sales2;

DELIMITER $$
CREATE TRIGGER before_sales_update
BEFORE UPDATE
on sales for each row
BEGIN
	DECLARE errorMessage VARCHAR(255);
    set errorMessage = CONCAT('the new quantity',NEW.quantity,'cannot be 3 times greater than current quantity',
    OLD.quantity);
    IF new.quantity > old.quantity * 3 THEN
		SIGNAL SQLSTATE '45000'
			set MESSAGE_TEXT = errorMessage;
	END IF;
END $$
UPDATE SALES2 SET quantity =2000 WHERE ID =2;

-- after use
DELIMITER $$
create trigger after_sales
after update
on sales2 for each row
-- precedes after_sales2
begin
	declare errormessage varchar(250);
    set errormessage = concat(New.quantity,'after sales cannot be used because its 3 times higher than, OLD.quantity');
    if new.quantity > old.quantity * 3 THEN
		signal sqlstate '22001'
			set MESSAGE_TEXT = errormessage;
            
	end if;
end $$
-- drop trigger after_sales2;

DELIMITER $$
create trigger after_sales2
after update
on sales2 for each row
follows after_sales
begin
	declare errormessage varchar(250);
    set errormessage = concat(New.quantity,' cannot be used because its 3 times higher than, OLD.quantity');
    if new.quantity > old.quantity * 3 THEN
		signal sqlstate '45000'
			set MESSAGE_TEXT = errormessage;
            
	end if;
end $$

show errors;

select trigger_name,action_order from information_schema.triggers
where trigger_schema= 'monday22'
order by event_object_table,
action_timing,
event_manipulation
-- -------------------
-- table with delete, insert, after

CREATE TABLE employee_data (
  id INT PRIMARY KEY,
  name VARCHAR(250),
  salary DECIMAL(10, 2)
);

CREATE TABLE audit_log (
  id INT PRIMARY KEY AUTO_INCREMENT,
  event_type VARCHAR(20),
  event_data VARCHAR(250),
  event_timestamp TIMESTAMP
);

-- Trigger for DELETE event
DELIMITER //
CREATE TRIGGER employee_delete_trigger
AFTER DELETE ON employee_data
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (event_type, event_data, event_timestamp)
  VALUES ('DELETE', CONCAT('Deleted employee with ID ', OLD.id), CURRENT_TIMESTAMP);
END //

-- Trigger for INSERT event
DELIMITER //
CREATE TRIGGER employee_insert_trigger
AFTER INSERT ON employee_data
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (event_type, event_data, event_timestamp)
  VALUES ('INSERT', CONCAT('Inserted employee with ID ', NEW.id), CURRENT_TIMESTAMP);
END //

-- Trigger for error in UPDATE event
DELIMITER //
CREATE TRIGGER employee_update_trigger
AFTER UPDATE ON employee_data
FOR EACH ROW
BEGIN
  declare errormessage varchar(250);
    set errormessage = concat('there is an error, Id should be lessan than 15', New.id);
    if new.id > 15 THEN -- condition change varies
		signal sqlstate '22001'
			set MESSAGE_TEXT = errormessage;
	end if;
END //


INSERT INTO employee_data (id, name, salary)
VALUES (15, 'goku', 5000.00),
       (21, 'vegeta', 6000.00),
       (31, 'Mike', 4500.00);

UPDATE employee_data
SET salary = 5500.00
WHERE id = 16;


DELETE FROM employee_data
WHERE id = 3;

select * from audit_log


-- ------------======----------------=======----------------=========------------------------------

-- -- DUPLICATE KEY ERRORS  1062. DECLARE EXIT HANDLER FOR 1062
-- 1146  :- tABLE NOT THERE
-- declare exit handler for table not there
-- decalre exit handler sqsl state 23000

CALL insertSupplierProducts(1,1);
CALL insertSupplierProducts(1,2);
CALL insertSupplierProducts(1,3);
CALL insertSupplierProducts(1,3);
select * from SUPPLIERPRODUCTS
CREATE TABLE SUPPLIERPRODUCTS(supplierId int, productId Int, PRIMARY KEY(supplierId,productId))

-- -----===========================------------ activity -----------
drop table audit_log;
-- table with delete, insert, after
CREATE TABLE employee_data (
  id INT PRIMARY KEY,
  name VARCHAR(250),
  salary DECIMAL(10, 2)
);
CREATE TABLE audit_log (
  id INT PRIMARY KEY AUTO_INCREMENT,
  event_type VARCHAR(200),
  event_data VARCHAR(250),
  event_timestamp TIMESTAMP
);



-- Trigger for DELETE event
DELIMITER //
CREATE TRIGGER employee_delete_trigger
AFTER DELETE ON employee_data
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (event_type, event_data, event_timestamp)
  VALUES ('DELETE', CONCAT('Deleted employee with ID ', OLD.id), CURRENT_TIMESTAMP);
END //
-- Trigger for INSERT event
DELIMITER //
CREATE TRIGGER employee_insert_trigger
AFTER INSERT ON employee_data
FOR EACH ROW
BEGIN
  INSERT INTO audit_log (event_type, event_data, event_timestamp)
  VALUES ('INSERT', CONCAT('Inserted employee with ID ', NEW.id), CURRENT_TIMESTAMP);
END //
-- Trigger for error in UPDATE event

DELIMITER //
CREATE TRIGGER employee_update_trigger
AFTER UPDATE ON employee_data
FOR EACH ROW
BEGIN
  declare errormessage varchar(250);
    set errormessage = concat('there is an error, salary should be lessan than 5000; ', New.salary);
    if new.salary > 5000 THEN -- condition change varies
		signal sqlstate '22001'
			set MESSAGE_TEXT = errormessage;
	end if;
END //

drop trigger employee_update_trigger;
drop table employee_data;


UPDATE employee_data
SET salary = 5500.00
WHERE id = 1;

select * from employee_data;

call insert_employees(16,'rohan16',3010);
select * from employee_data;
select * from audit_log;

UPDATE employee_data
SET salary = 5500.00
WHERE id = 16;

DELETE FROM employee_data
WHERE id = 3;
select * from audit_log










