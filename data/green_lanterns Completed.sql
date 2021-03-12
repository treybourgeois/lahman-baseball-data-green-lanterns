--QUESTION 1:
/*SELECT COUNT (DISTINCT year)
FROM homegames; -- 146 Years

SELECT MIN(year) AS first_year, MAX(year) AS last_year
FROM homegames; -- 1871 - 2016 */ 
--QUESTION 2
/*SELECT namefirst, namelast, height
FROM people
ORDER BY height ASC; -- Eddie Gaedel is shortest player -- Height = 43 

--Question 3:

SELECT DISTINCT p.namefirst, p.namelast, SUM(salary)
FROM people AS p
INNER JOIN collegeplaying AS cp
ON p.playerid = cp.playerid
INNER JOIN salaries AS s
ON s.playerid = p.playerid
WHERE schoolid = 'vandy'
GROUP BY p.namefirst, p.namelast
ORDER by SUM(salary) DESC;

--Question 4:
SELECT CASE
	WHEN pos IN ('OF') THEN 'Outfield'
	WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	WHEN pos IN ('P','C') THEN 'Battery' END AS positions,
	SUM(po)
FROM fielding
WHERE yearid = 2016
GROUP BY positions;

--Question 5. 
SELECT CASE 
            WHEN yearid between 1920 AND 1929 then '1920s'
            WHEN yearid between 1930 AND 1939 then '1930s'
			WHEN yearid between 1940 AND 1949 then '1940s'
			WHEN yearid between 1950 AND 1959 then '1950s'
			WHEN yearid between 1960 AND 1969 then '1960s'
			WHEN yearid between 1970 AND 1979 then '1970s'
			WHEN yearid between 1980 AND 1989 then '1980s'
			WHEN yearid between 1990 AND 1999 then '1990s'
			WHEN yearid between 2000 AND 2009 then '2000s'
			ELSE '2010s' END AS decades,
			
		SUM(strike_out) AS total_strikeouts, SUM(home_run) AS total_homeruns,
        ROUND(avg(strike_out),2) AS so_per_game,
		ROUND(avg(home_run),2) AS so_per_game

FROM 
(SELECT yearid, so AS strike_out, hr as home_run
FROM batting) b
GROUP BY decades
ORDER BY decades -- strikeouts and homeruns seem to have linear relationship


--Question.6
SELECT b.playerid,p.namefirst,p.namelast, 
SUM(sb) AS stolen_base,SUM(CS) AS caught_stealing,
SUM(sb) + SUM(cs) AS stolen_base_attempts,
ROUND(SUM(sb)::decimal/(SUM(sb)::decimal+SUM(cs)::decimal),2) AS stolen_base_success_rate
FROM
 (SELECT DISTINCT playerid,sb,cs,(SUM(SB)+SUM(CS)) AS sb_attempt
FROM batting 
WHERE yearid=2016
GROUP BY playerid,sb,cs
HAVING (SUM(SB)+SUM(CS))!=0) b
INNER JOIN people AS p USING(playerid)
WHERE sb_attempt>=20
GROUP BY b.playerid,p.namefirst,p.namelast
ORDER BY stolen_base_success_rate DESC
----Chris Owings had the highest success rate .91 in 2016

--Question 7:
6:31
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
6:34

--Question 8: 
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

--QUESTION 9:
SELECT p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
FROM awardsmanagers AS am
INNER JOIN people AS p
ON am.playerid = p.playerid
INNER JOIN managers AS m
ON m.playerid = am.playerid
WHERE awardid = 'TSN Manager of the Year'
AND am.lgid = 'AL' OR am.lgid = 'NL'
GROUP BY p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
ORDER BY am.playerid;*/ 
--Question 10:
/*SELECT DISTINCT schoolname, COUNT(awardid)
FROM schools AS s
JOIN collegeplaying AS c
ON s.schoolid = c.schoolid
JOIN people AS p
ON p.playerid = c.playerid
JOIN awardsplayers AS ap
ON ap.playerid = p.playerid
WHERE s.schoolstate = 'TN'
GROUP BY s.schoolname
ORDER BY COUNT(awardid) DESC;*/




