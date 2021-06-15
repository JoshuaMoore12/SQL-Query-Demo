-- Select Statements

SELECT *
FROM movie;

--Select using Where Clause 

SELECT title AS Movies, director AS Director
FROM movie
WHERE YEAR LIKE '19%';

-- Joins

SELECT a.title AS Movies, b.stars AS Rating
FROM movie a
JOIN rating b ON b.mid = a.mid;

-- Inner Join

SELECT a.title AS Movies, b.ratingdate AS Review_Date, c.name AS reviewer
FROM movie a
RIGHT JOIN rating b ON a.mid = b.mID
JOIN reviewer AS c ON b.rid = c.rID;

--Outer Join

SELECT b.director, a.ratingdate 
FROM movie b 
OUTER JOIN reviewer AS a ON a.mid = b.mid;

--Aggregates

SELECT AVG(a.stars) AS Average_Score, b.title AS movie 
FROM rating a 
JOIN movie b ON a.mid = b.mid
GROUP BY a.MID;

-- Self Join

SELECT a.rid, a.mID
FROM rating a 
JOIN rating b ON a.rID = b.rid
WHERE a.ratingdate > b.ratingdate
AND a.stars > b.stars   
AND a.rid = b.rid;


-- More Complex SQL queries using subqueries and aggregates

-- shows which movies have the most reviews and who reviewed them 

SELECT title AS Movies, reviewer.name AS Reviewer
FROM movie 
JOIN rating ON movie.mid = rating.mid
JOIN reviewer ON rating.rid = reviewer.rid
WHERE movie.MID IN (	
SELECT t.mid 
FROM (	SELECT MID, COUNT(MID)
FROM rating
GROUP BY mid
order by (COUNT(MID)) desc
LIMIT 2) AS t)
;
      
-- Shows movies that were reviewed twice but received a higher review at a later date and the person who reviewed them 

SELECT distinct NAME AS Reviewer, title AS Movies, movie.mid as Movie_ID
FROM reviewer
JOIN rating ON rating.rid = reviewer.rid
JOIN movie ON rating.mid = movie.mid
WHERE reviewer.rid IN 
(			
SELECT a.rid
FROM rating a
join rating b ON a.rid = b.rid
WHERE a.ratingdate > b.ratingdate
AND a.stars > b.stars 
)
AND movie.MID in
(
SELECT a.mid
FROM rating a
JOIN rating b ON a.rid = b.rid
WHERE a.ratingdate > b.ratingdate
AND a.stars > b.stars	
);


--Shows a case statement that takes the average rating of a movie and gives a description on whether is was good or bad

SELECT AVG(stars) AS Average_Rating , b.MID AS Movie_ID, Title AS Movies,
CASE
WHEN AVG(stars) BETWEEN 2.00 AND 2.50 THEN 'Bad'
WHEN AVG(stars) BETWEEN 3.00 AND 3.50 THEN 'Okay'
WHEN AVG(stars) BETWEEN 4.00 AND 4.50 THEN 'Great'
WHEN AVG(stars) >= 5 THEN 'Amazing'
END AS Description
FROM rating a 
JOIN movie b ON a.mid = b.mid
GROUP BY a.mid ;
