
Use c361cohort;
select table_name, engine from information_schema.tables where table_name = 'employee1';
alter table employee1 engine='MyISAM';
repair table employee1;
select * from employee1;
-- myisam : heavy select queries
-- innnodb : pk forign relationnship
select * from information_schema.tables;

-- SQL Query engine :-
-- 	A parser :- breaking components
--     A lexer :- identifying the tokens 
--     semantic analyzer :- meaning of sql query
--     optimizer :- best way to execute sql query
--     query executor :- retruning the query

show table status;

Create temporary table alpha(id int, name varchar(255))

-- common table expression
with my_cte as (select namex from employee1)
select namex from my_cte;

lock table employee1 read; -- if write is written , nothing is lock
unlock tables;
insert into employee1(id, first_name) values(112 , 'rohan');
select * from employee1;
ALTER TABLE employee CHANGE COLUMN name namex VARCHAR(100);

-- ALTER USER account_name IDENTIFIED BY 'password' ACCOUNT LOCK;
ALTER USER root@localhost ACCOUNT LOCK;
ALTER USER root@localhost ACCOUNT UNLOCK;

select user();

create view tempy as select namex from employee union select names as namex from employee1;
select * from tempy;

create table employee(name VARCHAR(100) NOT NULL);
insert into employee(namex) values('roh');
select * from employee;


-- Order by : - sort the rows - returned by sql select statements
select * from tempy order by namex desc;

-- group by : group together for a common value - calculate aggregate
select names , count(*) as num_users from employee1 group by  names having num_users> 1;

-- join

create table users( id int not null auto_increment, name varchar(255) not null , primary key(id));

create table orders(id int not null auto_increment, user_id int not null, order_id int not null, 
primary key(id), foreign key(user_id) references users(id));

insert into users(name) values('john');
insert into users(name) values('akjshdkjshdjkhasdh');

insert into orders(user_id, order_id) values(1,1000);
insert into orders(user_id, order_id) values(2,5000);

select * from users;
select * from orders;
select u.name , o.order_id
from users u join orders o on u.id = o.user_id;



CREATE TABLE ActorDirector (
  actor_id INT NOT NULL,
  director_id INT NOT NULL,
  timestamp INT NOT NULL,
  PRIMARY KEY (actor_id, director_id, timestamp)
);

INSERT INTO ActorDirector (actor_id, director_id, timestamp) VALUES
(1, 1, 0),
(1, 1, 1),
(1, 1, 2),
(1, 2, 3),
(1, 2, 4),
(2, 1, 5),
(2, 1, 6);

select * from actordirector;

select actor_id, director_id from ActorDirector where actor_id=director_id group by actor_id, director_id having count(*)>=2;

select distinct ad.actor_id FROM ActorDirector ad JOIN Actor a ON ad.actor_id = a.actor_id ;


-- Write an SQL query to find all the authors that viewed at least one of their own articles, sorted in ascending order by their id.


CREATE TABLE ArticleViews (
  article_id INT NOT NULL,
  author_id INT NOT NULL,
  viewer_id INT NOT NULL,
  view_date DATE NOT NULL,
  PRIMARY KEY (article_id, viewer_id)
);

INSERT INTO ArticleViews (article_id, author_id, viewer_id, view_date) VALUES
(1, 3, 5, '2019-08-01'),
(1, 3, 6, '2019-08-02'),
(2, 7, 7, '2019-08-01'),
(2, 7, 6, '2019-08-02'),
(4, 7, 1, '2019-07-22'),
(3, 4, 4, '2019-07-21');

select distinct author_id from articleviews where Author_id = Viewer_id order by author_id;
select distinct a.author_id from articleviews a join articleviews av on av.author_id = a.Viewer_id order by a.author_id; 




CREATE TABLE Prices (
  product_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  PRIMARY KEY (product_id, start_date)
);

INSERT INTO Prices (product_id, start_date, end_date, price) VALUES
(1, '2019-02-17', '2019-02-28', 5.00),
(1, '2019-03-01', '2019-03-22', 20.00),
(2, '2019-02-01', '2019-02-20', 15.00),
(2, '2019-02-21', '2019-03-31', 30.00);

CREATE TABLE UnitsSold (
  product_id INT NOT NULL,
  purchase_date DATE NOT NULL,
  units INT NOT NULL,
  PRIMARY KEY (product_id, purchase_date)
);

INSERT INTO UnitsSold (product_id, purchase_date, units) VALUES
(1, '2019-02-25', 100),
(1, '2019-03-01', 15),
(2, '2019-02-10', 200),
(2, '2019-03-22', 30);


select us.product_id , round(sum(us.units * p.price)/ sum(us.units),2) as avg_price from unitssold as us
join prices p on p.product_id = us.product_id and us.purchase_date >= p.start_date 
and us.purchase_date <= p.end_date
group by us.product_id;

-- another using natural join
select p.product_id ,round((sum(p.price*s.units)/sum(s.units)),2) as average_Selling_price
from Prices p  natural join UnitsSold s
where s.purchase_date between p.start_date and p.end_date
group by p.product_id;

CREATE TABLE Number (
  num INT NOT NULL
);
INSERT INTO Number (num) VALUES
(8),
(8),
(3),
(3),
(1),
(4),
(5),
(6);
-- Table my_numbers contains many numbers in column num including duplicated ones.

select max(distinct num) from number; 

-- Can you write a SQL query to find the biggest number, which only appears once.

-- Write a SQL query for a report that provides the following information for each person in the Person table,
-- regardless if there is an address for each of those people:
CREATE TABLE Person (
  PersonId INT NOT NULL AUTO_INCREMENT,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(50) NOT NULL,
  PRIMARY KEY (PersonId)
);

CREATE TABLE Address (
  AddressId INT NOT NULL AUTO_INCREMENT,
  PersonId INT NOT NULL,
  City VARCHAR(50) NOT NULL,
  State VARCHAR(50) NOT NULL,
  PRIMARY KEY (AddressId)
);

insert into person(firstname, lastname) values('loha','kot'),('kame','hameha');
insert into address(personid,city,state) values(1,'bhopal', 'mp'),(3,'delhi','delhi');

select p.personid , p.firstname, p.lastname , a.city , a.state from person p
left join address a on p.personid = a.personid;

--  -------------------------------------

CREATE TABLE Customers (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

INSERT INTO Customers (id, name) VALUES
(1, 'Joe'),
(2, 'Henry'),
(3, 'Sam'),
(4, 'Max');

CREATE TABLE NOrders (
  id INT NOT NULL,
  customer_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (customer_id) REFERENCES Customers(id)
);

INSERT INTO NOrders (id, customer_id) VALUES
(1, 3),
(2, 1);

Select id, name from customers
where id not in ( select customer_id from Norders);


CREATE TABLE Employ (
  empId INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  supervisor INT,
  salary INT,
  PRIMARY KEY (empId)
);

INSERT INTO Employ (empId, name, supervisor, salary) VALUES
(1, 'John', 3, 1000),
(2, 'Dan', 3, 2000),
(3, 'Brad', NULL, 4000),
(4, 'Thomas', 3, 4000);

CREATE TABLE Bonus (
  empId INT NOT NULL,
  bonus INT,
  PRIMARY KEY (empId),
  FOREIGN KEY (empId) REFERENCES Employ(empId)
);

INSERT INTO Bonus (empId, bonus) VALUES
(2, 500),
(4, 2000);

Select  e.name, b.bonus from employ e join Bonus b on
e.empid = b.empid where b.bonus < 1000 ;


-- Write an SQL query that reports the first login date for each player.

CREATE TABLE Activity(
  player_id INT NOT NULL,
  device_id INT NOT NULL,
  event_date DATE NOT NULL,
  games_played INT,
  PRIMARY KEY (player_id, event_date)
);

INSERT INTO Activity(player_id, device_id, event_date, games_played) VALUES
(1, 2, '2016-03-01', 5),
(1, 2, '2016-05-02', 6),
(2, 3, '2017-06-25', 1),
(3, 1, '2016-03-02', 0),
(3, 4, '2018-07-03', 5);

select player_id, min(event_date) as first_date from activity group by player_id;

select p.player_id , p.event_date as first_date from activity p 
join activity a on p.player_id = a.player_id and p.event_date> a.event_date where a.player_id is NUll;


CREATE TABLE seat (
  seat_id INT NOT NULL,
  free BOOLEAN NOT NULL,
  PRIMARY KEY (seat_id)
);
INSERT INTO seat (seat_id, free) VALUES
(1, 1),
(2, 0),
(3, 1),
(4, 1),
(5, 1);

-- lead function determine next coming
-- lag is used for prev values

select seat_id from (select seat_id, free,lead(free,1) over() as next, 
lag(free,1) over() as prev from seat) a
where a.free=True and (next = True or prev=True)
order by seat_id;


--  lead lag example
create table employeestemp(name varchar(300) , salary bigint, emp_id int not null);

insert into employeestemp values('assass',7688,2);

insert into employeestemp values('aasdasdsads',762388,3);

insert into employeestemp values('addaassass',768812,4);

select name , salary , lead(salary,1) over(order by salary desc) as next_salary
from employeestemp;


create table t1(id int,year_col int) partition by range(year_col)(partition p0 values less than (1991),partition p1 values less than (2001),partition p2 values less than (2011),partition p3 values less than (2021))
