--2nd Task
--1.

SELECT TOP 100(sum(unitcost*overnights*persons)) as totalcost , fname,lname,d_countries.country
from f_bookings,d_customers,d_countries
WHERE d_customers.custid=f_bookings.custid
AND d_countries.cid=f_bookings.cid
GROUP BY fname,lname,d_countries.country
ORDER BY totalcost DESC



--2.

SELECT DISTINCT campName,category, sum(unitcost*overnights*persons) as profit
FROM f_bookings , d_camping , d_seats,d_timeinfo
WHERE d_timeinfo.startdate=f_bookings.startdate
AND f_bookings.campcode=d_camping.campcode
AND d_seats.catcode=f_bookings.catcode
AND t_year=2000
GROUP BY campName,category
ORDER BY campName,category

--3. 

SELECT DISTINCT t_month,campName,sum(unitcost*overnights*persons) as profit
FROM f_bookings,d_camping,d_seats,d_timeinfo
WHERE d_timeinfo.startdate=f_bookings.startdate
AND f_bookings.campcode=d_camping.campcode
AND t_year=2018
GROUP BY campName,t_month
ORDER BY campName,t_month




--4.

--a. 
SELECT COUNT(d_customers.custid) 
FROM d_customers,f_bookings
WHERE d_customers.custid=f_bookings.custid


--b.

SELECT COUNT(d_customers.custid) , t_year
FROM d_customers,f_bookings,d_timeinfo
WHERE d_customers.custid=f_bookings.custid
AND d_timeinfo.startdate=f_bookings.startdate
GROUP BY t_year
ORDER BY t_year DESC


--c.

SELECT COUNT(d_customers.custid) , t_year,campName
FROM d_customers,f_bookings,d_camping,d_timeinfo
WHERE d_customers.custid=f_bookings.custid
AND d_timeinfo.startdate=f_bookings.startdate
AND d_camping.campcode=f_bookings.campcode
AND d_camping.empno=f_bookings.empno
GROUP BY t_year,campName
ORDER BY t_year,campName 

--d.

SELECT COUNT(d_customers.custid) as totalcustomers , t_year,campName,category
FROM d_customers,f_bookings,d_camping,d_timeinfo,d_seats
WHERE d_customers.custid=f_bookings.custid
AND d_timeinfo.startdate=f_bookings.startdate
AND d_camping.campcode=f_bookings.campcode
AND d_camping.empno=f_bookings.empno
AND d_seats.catcode=f_bookings.catcode
GROUP BY t_year,campName,category
ORDER BY t_year,campName,category 


--ROLLUP

SELECT COUNT(d_customers.custid) as totalcustomers , t_year,campName,category
FROM d_customers,f_bookings,d_camping,d_timeinfo,d_seats
WHERE d_customers.custid=f_bookings.custid
AND d_timeinfo.startdate=f_bookings.startdate
AND d_camping.campcode=f_bookings.campcode
AND d_camping.empno=f_bookings.empno
AND d_seats.catcode=f_bookings.catcode
GROUP BY ROLLUP(t_year,campName,category)
ORDER BY t_year,campName,category 


--5.
GO	
CREATE VIEW v1 AS
SELECT campName,COUNT(d_customers.custid) AS totalcustomers,t_year
FROM d_camping,d_customers,f_bookings,d_timeinfo
WHERE d_timeinfo.startdate=f_bookings.startdate
AND d_camping.campcode=f_bookings.campcode
AND d_camping.empno=f_bookings.empno
AND d_customers.custid=f_bookings.custid
GROUP BY campName,t_year


SELECT A.campName, A.totalcustomers
FROM v1 AS A,v1 as B
WHERE A.campName=B.campName
AND A.t_year=2018 AND B.t_year=2017
AND A.totalcustomers>B.totalcustomers





--3rd Task

SELECT campName,category,persons,count(*) as totalnights
FROM d_camping,d_seats,f_bookings
WHERE d_camping.campcode=f_bookings.campcode
AND d_seats.catcode=f_bookings.catcode
GROUP BY CUBE(campName,category,persons)




