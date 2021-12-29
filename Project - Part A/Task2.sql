checkpoint
dbcc dropcleanbuffers

SET STATISTICS IO ON

--1.

select title
 from movies, movies_genre
 where movies.mid=movies_genre.mid and genre ='Adventure' 
 
 UNION ALL

 select title
 from movies, movies_genre
 where movies.mid=movies_genre.mid and genre ='Action'
 


 CREATE NONCLUSTERED INDEX index_genre ON Movies_Genre(genre) INCLUDE (mid)
 DROP INDEX index_genre ON movies_genre


 CREATE INDEX index_mid ON Movies(mid) INCLUDE (title)
 DROP INDEX index_mid ON movies



 --2.

 checkpoint
dbcc dropcleanbuffers

SET STATISTICS IO ON
 
 --1st Query

 SELECT DISTINCT title,Movies.mid
 FROM Movies,Actors,Roles
 WHERE Actors.aid=Roles.aid 
 AND Roles.mid=Movies.mid 
GROUP BY title,Movies.mid
HAVING SUM(case when Actors.gender='F' then 1 else 0 end)=0
INTERSECT
SELECT title,Movies.mid
 FROM Movies,Actors,Roles
 WHERE Actors.aid=Roles.aid 
 AND Roles.mid=Movies.mid 
GROUP BY title,Movies.mid
HAVING SUM(case when Actors.gender='M' then 1 else 0 end)>0




--1st Query,parallagi (OPTIMAL)

SELECT DISTINCT title,Movies.mid
 FROM Movies,Actors,Roles
 WHERE Actors.aid=Roles.aid 
 AND Roles.mid=Movies.mid 
GROUP BY title,Movies.mid
HAVING SUM(case when Actors.gender='F' then 1 else 0 end)=0
AND SUM(case when Actors.gender='M' then 1 else 0 end)>=1

--Indexes for Query1Parralagi

CREATE NONCLUSTERED INDEX index_aid ON Roles(aid) INCLUDE(mid) 
DROP INDEX index_aid ON Roles

CREATE INDEX index_title ON Movies(title) INCLUDE(mid)
DROP INDEX index_title ON Movies

CREATE INDEX index_aid ON Actors(aid) INCLUDE (gender)
DROP INDEX index_aid ON Actors

checkpoint
dbcc dropcleanbuffers

-- 2nd Query

SELECT distinct title,Movies.mid
FROM movies,roles,actors
WHERE Movies.mid=Roles.mid
AND Actors.aid=Roles.aid
AND gender='M'
EXCEPT
SELECT distinct title,Movies.mid
FROM movies,roles,actors
WHERE Movies.mid=Roles.mid
AND Actors.aid=Roles.aid
AND gender='F'

checkpoint
dbcc dropcleanbuffers

