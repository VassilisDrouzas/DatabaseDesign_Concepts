
-----------------------------------------CLEAN BUFFERS--------------------------------------------------------

checkpoint
dbcc dropcleanbuffers

SET STATISTICS IO ON


------------------------------------------FIRST TASK--------------------------------------------------------


--1.


SELECT title FROM MOVIES WHERE pyear between 1990 and 2000


SELECT pyear,title FROM movies WHERE pyear between 1990 and 2000

SELECT title,pyear FROM movies WHERE pyear between 1990 and 2000 
ORDER BY pyear,title

CREATE INDEX index_pyear ON movies(pyear) INCLUDE (title)
DROP INDEX index_pyear ON movies


--2.


select mid, count(rating)
 from user_movies group by mid order by mid


 select userid, count(rating)
 from user_movies group by userid order by userid

 /* None of these helped
 
 CREATE INDEX index_userid ON user_movies(userid,mid) 
 DROP INDEX index_userid ON user_movies
 
 CREATE INDEX index_mid ON user_movies(mid) INCLUDE (userid)
 DROP INDEX index_mid ON user_movies
 
 CREATE INDEX index_rating ON user_movies(rating) INCLUDE (userid)
 DROP INDEX index_rating ON user_movies
 */



 CREATE INDEX index_userid ON user_movies(userid) INCLUDE (mid,rating) 
 DROP INDEX index_userid ON user_movies


checkpoint
dbcc dropcleanbuffers

SET STATISTICS IO ON