--1a.Table 'campdata' creation

CREATE TABLE campdata(
	custid int,
	fname varchar(30),
	lname varchar(30),
	cid int,
	country varchar(30),
	bookid int,
	bookdate date,
	campcode char(3),
	campName varchar(50),
	empno int,
	catcode char(1),
	category varchar(20),
	unitcost numeric(4,2),
	startdate date,
	overnights int,
	persons int
)
--1b.Insert data in the table

BULK INSERT campdata
FROM 'C:\Users\user\Desktop\CAMPDATA.TXT'
WITH (FIRSTROW =2, FIELDTERMINATOR='|', ROWTERMINATOR = '\n');


--2. 

--d: Dimension Table
--f: Fact Table

CREATE TABLE d_countries(
cid int primary key,
country varchar(30)
)

CREATE TABLE d_camping(
campcode char(3),
campName varchar(50),
empno int,
primary key (campcode,empno)
)

CREATE TABLE d_customers(
custid int primary key,
fname varchar(30),
lname varchar(30),
cid int,
country varchar(30)
)

CREATE TABLE d_seats(
catcode char(1) primary key,
category varchar(20)
)

CREATE TABLE d_timeinfo(
startdate date primary key,
t_dayofyear int,
t_month int,
t_year int
)

CREATE TABLE f_bookings(
bookid int,
cid int,
campcode char(3),
empno int,
custid int,
catcode char(1),
bookdate date,
unitcost numeric(4,2),
startdate date,
overnights int,
persons int,

primary key(bookid,cid,campcode,empno,custid,catcode,startdate),
foreign key(cid) references d_countries(cid),
foreign key(campcode,empno) references d_camping(campcode,empno),
foreign key(custid) references d_customers(custid),
foreign key(catcode) references d_seats(catcode),
foreign key (startdate) references d_timeinfo(startdate)
)

DROP TABLE f_bookings
DROP TABLE d_countries
DROP TABLE d_camping
DROP TABLE d_customers
DROP TABLE d_seats
DROP TABLE d_timeinfo


--3.

insert into d_countries
select distinct cid,country
from campdata

insert into d_camping							
select distinct campcode,campName, empno
from campdata


insert into d_customers
select distinct custid,fname,lname ,cid,country
from campdata


insert into d_seats
select distinct catcode,category
from campdata

set datefirst 1;
insert into d_timeinfo
select distinct startdate, datepart(day,startdate),
datepart(month,startdate),datepart(year,startdate)
from campdata

insert into f_bookings									
select bookid,cid,campcode,empno,custid,catcode,bookdate,
sum(unitcost),startdate, sum(overnights),sum(persons)
from campdata
group by bookid,cid,campcode,empno,custid,catcode,bookdate,startdate

