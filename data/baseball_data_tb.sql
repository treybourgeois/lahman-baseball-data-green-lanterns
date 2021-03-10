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

SELECT DISTINCT p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
FROM people AS p
INNER JOIN awardsmanagers AS am
ON p.playerid = am.playerid
INNER JOIN managers AS m
ON m.playerid = am.playerid
AND awardid LIKE 'TSN Manager of the Year' 
AND am.lgid <> 'ML'
GROUP BY p.namefirst, p.namelast, am.lgid, am.playerid, m.teamid
ORDER BY p.namelast;



