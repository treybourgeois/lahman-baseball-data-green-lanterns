select *
from allstarfull;
select * 
from schools;

--1. What range of years for baseball games played does the provided database cover?
SELECT max(yearid), min(yearid)
FROM appearances;
--145 years (1871-2016)

/*Trey #1*/
SELECT COUNT (DISTINCT year)
FROM homegames; -- 1.) 146 Years
SELECT MIN(year) AS first_year, MAX(year) AS last_year
FROM homegames; -- 1.) 1871 - 2016 */

/*#2,Find the name and height of the shortest player in the database*/
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
	
	/*Trey #2*/
	SELECT namefirst, namelast, height
FROM people
ORDER BY height ASC; -- Eddie Gaedel is shortest player -- Height = 43
SELECT DISTINCT name, p.playerid, COUNT(g_all)
FROM teams AS t
LEFT JOIN appearances AS a
ON t.teamid = a.teamid
LEFT JOIN people AS p
ON a.playerid = p.playerid
WHERE p.playerid = 'gaedeed01'
GROUP BY t.name, p.playerid; --St. Louis Browns was the team he played for, playing a total of 52 games.*/ --
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

/*Collin#3*/
SELECT DISTINCT p.playerid, p.namefirst, p.namelast, SUM(s.salary) OVER(Partition by p.playerid) AS total_salary
FROM collegeplaying AS c
JOIN people AS p
ON c.playerid = p.playerid
JOIN salaries AS s
ON s.playerid = p.playerid
WHERE c.schoolid = 'vandy'
GROUP BY p.playerid, s.yearid, p.namefirst, p,namelast, s.salary
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

/*Collin #4*/
SELECT CASE
	WHEN pos IN ('OF') THEN 'Outfield'
	WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	WHEN pos IN ('P','C') THEN 'Battery' END AS positions,
	SUM(po)
FROM fielding
WHERE yearid = 2016
GROUP BY positions;


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

/*alternative#7*/
WITH champ AS(
SELECT yearid,name,MAX(w) AS wins
FROM teams WHERE yearid>=1970 AND yearid!=1981 AND yearid!= 1994 AND wswin='Y' group by yearid, name order by yearid)			  
, 
max_wins AS(
SELECT yearid,MAX(w) AS wins
FROM teams WHERE yearid>=1970 AND yearid!=1981  AND yearid != 1994 
group by yearid
order by yearid)
SELECT champ.yearid,champ.name AS ws_champs,champ.wins AS ws_champion_wins,max_wins.wins AS max_regular_season_wins
FROM champ,max_wins
WHERE champ.yearid=max_wins.yearid

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
/*  numb 8 altern*/
SELECT teams.name,park_name,homegames.attendance,games,homegames.attendance/games AS attendance_per_game
FROM homegames
INNER JOIN parks ON homegames.park=parks.park
AND year=2016 AND games>1
INNER JOIN teams ON homegames.team=teams.teamid AND homegames.year=teams.yearid
WHERE teams.yearid>1960
ORDER BY attendance_per_game DESC
LIMIT 5
--bottom 5
SELECT teams.name,park_name,homegames.attendance,games,homegames.attendance/games AS attendance_per_game
FROM homegames
INNER JOIN parks ON homegames.park=parks.park
AND year=2016 AND games>1
INNER JOIN teams ON homegames.team=teams.teamid AND homegames.year=teams.yearid
WHERE teams.yearid>1960
ORDER BY attendance_per_game 
LIMIT 5
/* 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) 
and the American League (AL)? Give their full name and the teams that they were managing when 
they won the award.*/

SELECT *
FROM awardsmanagers;

SELECT * 
FROM people;

SELECT *
FROM managers;


SELECT namefirst, namelast, teamid
FROM awardsmanagers
LEFT JOIN people
USING (playerid)
LEFT JOIN managers
USING (playerid) 

WITH TSN AS (SELECT *
			FROM awardsmanagers
			WHERE awardid LIKE 'TSN%'),
lg AS (SELECT playerid, lg1.yearid as NL_year, lg2.yearid as AL_year
		FROM TSN as lg1
		LEFT JOIN TSN as lg2
		USING (playerid)
		WHERE lg1.lgid = 'NL'
		AND lg2.lgid = 'AL'), 
award_recipients AS (SELECT playerid, NL_year as award_year
					FROM lg
					UNION ALL 
					SELECT DISTINCT(playerid), AL_year
					FROM lg 
					ORDER BY playerid),
testing AS (SELECT ar.playerid, namefirst, namelast, award_year, m.teamid
			FROM award_recipients as ar
			LEFT JOIN managers as m
			ON ar.playerid = m.playerid and ar.award_year = m.yearid
			LEFT JOIN people
			ON m.playerid = people.playerid)
SELECT namefirst, namelast, award_year, name
FROM testing 
LEFT JOIN teams
ON testing.teamid = teams.teamid and testing.award_year = teams.yearid;

SELECT *
FROM people;

SELECT *
FROM awardsmanagers
LEFT JOIN 
/#10*/
SELECT DISTINCT s.schoolname, s.schoolstate, namefirst, namelast, COUNT(hof.votes) AS HOF_VOTES, hof.inducted, hof.category
FROM collegeplaying AS cp
JOIN schools AS s
ON cp.schoolid = s.schoolid
JOIN people AS p
ON p.playerid = cp.playerid
JOIN halloffame AS hof
ON hof.playerid = p.playerid
WHERE s.schoolstate = 'TN'
GROUP BY s.schoolname, s.schoolstate, namefirst, namelast, hof.inducted, hof.category
ORDER BY hof_votes DESC;

/*#10 Abdula*/
SELECT s.schoolname,s.schoolid, a.yearid ,COUNT(a.awardid) AS awards
FROM 
(SELECT *
 schools as s
LEFT JOIN collegeplaying AS c
ON s.schoolid = c.schoolid
LEFT JOIN people as p
ON c.playerid = p.playerid
LEFT JOIN awardsplayers as a
ON p.playerid = a.playerid
WHERE s.schoolstate = 'TN'
GROUP BY s.schoolname,s.schoolid, a.awardid
ORDER BY awards DESC;


