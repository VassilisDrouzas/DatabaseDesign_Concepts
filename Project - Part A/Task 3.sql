set statistics io on

checkpoint
dbcc dropcleanbuffers


--1. Δείξε τις ταινίες οι οποίες έχουν άριστη βαθμολογία (>=8.5) σε φθίνουσα σειρά
-- με θέμα 'Action' και λιγότερους από 6 ηθοποιούς.

SELECT Movies.title,COUNT(Actors.aid) as Number_of_Actors,mrank
FROM Movies,Roles,Movies_genre,Actors
WHERE Movies.mid=Movies_Genre.mid
AND Movies.mid=Roles.mid
AND Actors.aid=Roles.aid
AND Movies_Genre.genre='Action'
AND Movies.mrank>=8.5
GROUP BY title,Movies.mrank
HAVING COUNT(Actors.aid)<6
ORDER BY mrank DESC

/*
CREATE INDEX index_genre ON Movies_Genre(genre) INCLUDE (mid)
DROP INDEX index_genre ON Movies_Genre
*/

-- INDEXES--

CREATE INDEX index_genre_mid ON Movies_Genre(genre,mid)
DROP INDEX index_genre_mid ON Movies_Genre

CREATE INDEX index_mrank on Movies(mrank) INCLUDE(title,mid)
DROP INDEX index_mrank ON Movies

CREATE INDEX index_aid ON Roles(aid) INCLUDE (mid)
DROP INDEX index_aid on Roles

CREATE INDEX index_aid ON Actors(aid)
DROP INDEX index_aid ON Actors





--2. Δείξε μας τις adventure ταινίες του 21ου αιώνα σε φθίνουσα σειρά 
-- ανάλογα με τη βαθμολογία (να είναι τουλάχιστον 3) που έχουν λάβει από τους 
-- χρήστες , οι οποίοι να είναι ηλικιακά 'νέοι' (18-35 ετών)

--Πιθανόν ο λόγος που επιλέγουμε να φιλτράρουμε το κοινό είναι επειδή οι ταινίες -- αυτές έχουν αυξημένη απήχηση στο κοινό αυτό,άρα και οι βαθμολογίες αυτές
--θα είναι πιο αντιπροσωπευτικές.

SELECT title,pyear,rating
FROM Movies,Movies_Genre,User_Movies,Users
WHERE Movies.mid=Movies_Genre.mid
AND movies.mid=User_Movies.mid
AND User_Movies.userid=Users.userid
AND rating>=3
AND genre='Adventure'
AND pyear BETWEEN 2000 AND 2021
AND age BETWEEN 18 AND 35
GROUP BY title,pyear,rating
ORDER BY rating DESC

--Indexes--

CREATE INDEX index_genre ON Movies_Genre(genre) INCLUDE (mid)
DROP INDEX index_genre ON Movies_Genre

CREATE INDEX index_pyear ON Movies(pyear) INCLUDE(title)
DROP INDEX index_pyear ON Movies




checkpoint
dbcc dropcleanbuffers