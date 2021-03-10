select *
from allstarfull;
select * 
from schools;

--1. What range of years for baseball games played does the provided database cover?
SELECT max(yearid), min(yearid)
FROM appearances;
--145 years (1871-2016)
/*#2,2.	Find the name and height of the shortest player in the database*/
select namefirst,namelast, height
from people
order by height
limit 1;
/* (rest of #2)How many games did he play in? What is the name of the team for which he played?*/
SELECT people.playerid, namefirst, namegiven, namelast, g_all as games, height as height_inches, teams.name
	FROM people INNER JOIN appearances ON people.playerid = appearances.playerid
		INNER JOIN teams ON teams.teamid = appearances.teamid
	WHERE people.playerid = 'gaedeed01'
	LIMIT 1;
	/* 3. Find all players in the database who played at Vanderbilt University. 
Create a list showing each player’s first and last names as well as the total salary they earned 
in the major leagues. Sort this list in descending order by the total salary earned. 
Which Vanderbilt player earned the most money in the majors? */

WITH vandy AS (SELECT *
				FROM collegeplaying
				WHERE schoolid = 'vandy'), 
	vandy_names	AS (SELECT DISTINCT(playerid), namefirst, namelast
			   FROM vandy
			   LEFT JOIN people
			   USING(playerid))
SELECT DISTINCT(playerid), namefirst, namelast, SUM(salary) OVER(PARTITION BY playerid) as total_salary
FROM vandy_names
LEFT JOIN salaries
USING(playerid)
WHERE salary IS NOT NULL
ORDER BY total_salary DESC;

/* 4. Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", 
and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
Determine the number of putouts made by each of these three groups in 2016.*/

SELECT *
FROM fielding;

SELECT 
	CASE WHEN pos = 'OF' THEN 'Outfield'
		WHEN pos IN ('SS', '1B', '2B', '3b') THEN 'Infield'
		ELSE 'Battery' END as field_position, SUM(po) as total_putouts
FROM fielding
WHERE yearid = 2016
GROUP BY field_position;

/* 5. Find the average number of strikeouts per game by decade since 1920. 
Round the numbers you report to 2 decimal places. Do the same for home runs per game. 
Do you see any trends?*/
SELECT yearid/10*10 as decade, ROUND(AVG(so::numeric/g::numeric), 2) as avg_so_per_game, ROUND(AVG(hr::numeric/g::numeric),2) as avg_h_per_game
FROM teams
WHERE yearid BETWEEN 1920 AND 2016
GROUP BY decade
ORDER BY decade;


/*Select avg(SO) as averageS_trikeouts ,decade||'-'||decade+9 as period
FROM (SELECT (CAST ((yearID/10) as int) *10) as decade
	  FROM PitchingPost
	  WHERE (CAST ((yearID/10) as int) *10) IS NOT NULL
	  GROUP BY decade
	  order by decade asc) as sub
     
SELECT *
FROM pitchingpost*/

/*6. Find the player who had the most success stealing bases in 2016, where success is measured as 
the percentage of stolen base attempts which are successful. (A stolen base attempt results either 
in a stolen base or being caught stealing.) Consider only players who attempted at least 20 
stolen bases.*/
SELECT playerid, namefirst, namelast, cs, sb, cs+sb as attempts, ROUND((sb::float/(cs::float+sb::float))::numeric, 2) as success
FROM batting
LEFT JOIN people
USING(playerid)
WHERE yearid = 2016
and SB >= 20
ORDER BY success DESC

	
	
/*#7, From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? Doing this will 
probably result in an unusually small number of wins for a world series champion – determine why 
this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was 
it the case that a team with the most wins also won the world series? What percentage of the time?*/
SELECT name as team_name, yearid as year, w as wins, wswin as world_series_win
FROM teams
WHERE wswin IS NOT null
AND yearid BETWEEN 1969 AND 2017
AND wswin = 'N'
ORDER BY wins DESC;

SELECT name as team_name, yearid as year, w as wins, wswin as world_series_win
FROM teams
WHERE wswin IS NOT null
AND yearid BETWEEN 1969 AND 2017
AND wswin = 'Y'
ORDER BY wins;

SELECT name as team_name, yearid as year, w as wins, wswin as world_series_win
FROM teams
WHERE wswin IS NOT null
AND yearid BETWEEN 1969 AND 2017
AND wswin = 'Y'
AND yearid <> 1981 --AND yearid NOT BETWEEN '1981' AND '1981'
ORDER BY wins;

/*8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 
average attendance per game in 2016 (where average attendance is defined as total attendance divided
by number of games). Only consider parks where there were at least 10 games played. 
Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.*/

WITH avg_atten as (select team, attendance/games as average
			   from homegames
			   where year = 2016)
select *
from homegames
left join avg_atten
using (team)
where year = 2016
and games > 10
order by average desc
limit 5

WITH avg_attend as (SELECT team, park, ROUND(attendance::float/games::float) as avg_attendance
				 	 FROM homegames
				  	WHERE year = 2016
				  	AND games >= 10 )
SELECT team, teams.name, park_name, avg_attendance
FROM avg_attend
LEFT JOIN parks
USING(park)
LEFT JOIN teams
ON avg_attend.team = teams.teamid
WHERE teams.yearid = 2016
ORDER BY avg_attendance DESC;

SELECT * 
FROM teams

