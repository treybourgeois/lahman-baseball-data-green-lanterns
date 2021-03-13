/*SELECT COUNT (DISTINCT year)
FROM homegames; -- 1.) 146 Years

SELECT MIN(year) AS first_year, MAX(year) AS last_year
FROM homegames; -- 1.) 1871 - 2016 */ -- QUESTION 1

/*SELECT namefirst, namelast, height
FROM people
ORDER BY height ASC; -- Eddie Gaedel is shortest player -- Height = 43


SELECT DISTINCT namelast, namefirst, playerid
FROM people
WHERE namelast = 'Gaedel'; --gaedeed01 is his playerid

SELECT DISTINCT name, p.playerid, COUNT(g_all)
FROM teams AS t
LEFT JOIN appearances AS a
ON t.teamid = a.teamid
LEFT JOIN people AS p
ON a.playerid = p.playerid
WHERE p.playerid = 'gaedeed01'
GROUP BY t.name, p.playerid; --St. Louis Browns was the team he played for, playing a total of 52 games.*/ -- QUESTION 2

/*SELECT p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
FROM awardsmanagers AS am
INNER JOIN people AS p
ON am.playerid = p.playerid
INNER JOIN managers AS m
ON m.playerid = am.playerid
WHERE awardid = 'TSN Manager of the Year' 
AND am.lgid = 'AL' OR am.lgid = 'NL'
GROUP BY p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
ORDER BY am.playerid;*/ -- QUESTION 9

SELECT DISTINCT p.namefirst, p.namelast, SUM(salary) AS career_salary
FROM people AS p
INNER JOIN collegeplaying AS cp
ON p.playerid = cp.playerid
INNER JOIN salaries AS s
ON s.playerid = p.playerid
WHERE schoolid = 'vandy'
GROUP BY p.namefirst, p.namelast, p.playerid
ORDER BY SUM(salary) DESC;

SELECT DISTINCT p.playerid, s.schoolname, s.schoolstate, namefirst, namelast, hof.votes AS HOF_VOTES, hof.inducted, hof.category
FROM collegeplaying AS cp
INNER JOIN schools AS s
ON cp.schoolid = s.schoolid
INNER JOIN people AS p
ON p.playerid = cp.playerid
INNER JOIN halloffame AS hof
ON hof.playerid = p.playerid
WHERE s.schoolstate = 'TN'
GROUP BY s.schoolname, s.schoolstate, namefirst, namelast, hof.inducted, hof.category, p.playerid, hof.votes
ORDER BY p.playerid ASC;

SELECT s.schoolname, COUNT(ap.awardid) AS awards, ap.awardid AS award_title
FROM awardsplayers AS ap
INNER JOIN people AS p
ON p.playerid = ap.playerid
INNER JOIN collegeplaying AS cp
ON cp.playerid = p.playerid
INNER JOIN schools AS s 
ON s.schoolid = cp.schoolid
WHERE s.schoolid IN
	(SELECT schoolid
	FROM schools 
	WHERE schoolstate = 'TN')
GROUP BY s.schoolname, award_title
ORDER BY awards DESC;


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

SELECT namefirst, namelast
FROM people AS p

SELECT p.namefirst, p.namelast, t.lgid, t.name
FROM people AS p
INNER JOIN managershalf AS mh
ON p.playerid = mh.playerid
INNER JOIN teams AS t
ON mh.teamid = t.teamid
WHERE p.namelast = 'Cox'
GROUP BY t.lgid, t.name, p.namelast, p.namefirst;

SELECT yearid, SUM(po) AS total_putouts,
CASE WHEN pos = 'OF' THEN 'Outfield'
	 WHEN pos = '1B' OR pos = '2B' OR pos = '3B' OR pos = 'SS' THEN 'Infield'
	 WHEN pos = 'P' OR pos = 'C' THEN 'Battery'
END AS position_group
FROM fielding
WHERE yearid = '2016'
GROUP BY yearid, position_group
ORDER BY total_putouts DESC;


SELECT TRUNC(yearid, -1) AS decade, ROUND(AVG(so), 2) AS avg_strikeouts_per_game, COUNT(g),
ROUND(AVG(hr), 2) AS avg_homers_per_game
FROM battingpost AS bp
WHERE TRUNC(yearid, -1) >= 1920
Group by decade
ORDER BY decade;

SELECT TRUNC(yearid, -1) AS decade, ROUND(AVG(so), 2) AS avg_strikeouts_per_game,
ROUND(AVG(hr), 2) AS avg_homers_per_game
FROM pitching
WHERE TRUNC(yearid, -1) >= 1920
Group by decade
ORDER BY decade;

SELECT playerid, b.sb AS stolen_bases, b.cs AS caught_stealing, (sb + cs) AS steal_attempts, ROUND(1.0 * sb / (sb+cs),2) AS stealing_perc
FROM batting AS b
WHERE yearid = '2016' AND sb >= 20
GROUP BY b.playerid, b.yearid, b.cs, b.sb
ORDER BY stealing_perc DESC

SELECT 	p.namefirst, 
		p.namelast,
		teamid, 
		sb, 
		cs,
		(sb + cs) AS steal_attempts,
		ROUND(1.00 * sb / (sb + cs),3) AS stolen_bases_perc					
FROM batting AS b
JOIN people AS p
ON b.playerid = p.playerid
WHERE yearid = 2016 AND sb >= 20
ORDER BY stolen_bases_perc DESC

WITH ws_champ AS 
	(SELECT yearid,
			g,
			teamid,
			w
	FROM teams
	WHERE wswin = 'N'
	AND yearid BETWEEN 1970 AND 2016)
SELECT yearid,
		g,
		teamid,
		w
FROM ws_champ
WHERE w = (SELECT MAX(w) FROM ws_champ);


SELECT yearid,
			MAX(w) AS max_w
	FROM teams
	WHERE yearid BETWEEN 1970 AND 2016
	GROUP BY yearid


SELECT SUM(CASE WHEN wswin = 'Y' THEN 1 ELSE 0 END) AS ct_max_is_champ,
		ROUND(100*AVG(CASE WHEN wswin = 'Y' THEN 1 ELSE 0 END), 2) AS perc_max_is_champ
FROM max_ws_champ AS m
INNER JOIN teams AS t
ON m.yearid = t.yearid AND m.max_w = t.w


WITH NL_TSN AS
	(SELECT playerid
	FROM awardsmanagers AS aw
	WHERE awardid LIKE 'TSN %'
	AND lgid = 'NL'),
AL_TSN AS
	(SELECT playerid
	FROM awardsmanagers AS aw
	WHERE awardid LIKE 'TSN %'
	AND lgid = 'AL')
SELECT DISTINCT am.playerid,
		p.namefirst,
		p.namelast,
		am.lgid,
		am.yearid,
		tf.franchname
FROM awardsmanagers AS am
LEFT JOIN managers AS m
USING (playerid, yearid)
LEFT JOIN teamsfranchises AS tf
ON m.teamid = tf.franchid
LEFT JOIN people AS p
USING (playerid)
WHERE playerid IN
	(SELECT *
	FROM NL_TSN
	INTERSECT
	SELECT *
	FROM AL_TSN)
ORDER BY namelast, yearid;


SELECT a.playerid, a.yearid, a.lgid, p.namefirst, p.namelast, m.teamid
FROM awardsmanagers AS a
LEFT JOIN people AS p
ON a.playerid = p.playerid
LEFT JOIN managers as m
ON a.playerid = m.playerid AND a.yearid = m.yearid
WHERE awardid = 'TSN Manager of the Year' AND a.playerid IN (
SELECT playerid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year' AND lgid = 'NL'
INTERSECT
SELECT playerid
FROM awardsmanagers
WHERE awardid = 'TSN Manager of the Year' AND lgid = 'AL')

SELECT p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
FROM awardsmanagers AS am
LEFT JOIN people AS p
ON am.playerid = p.playerid
LEFT JOIN managers AS m
ON m.playerid = am.playerid AND m.yearid = am.yearid
WHERE awardid = 'TSN Manager of the Year' AND am.playerid IN
(SELECT playerid
FROM awardsmanagers WHERE lgid = 'AL'
 INTERSECT
 SELECT playerid
 FROM awardsmanagers WHERE lgid = 'NL');





















