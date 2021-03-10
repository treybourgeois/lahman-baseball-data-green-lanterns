--Question 3: David Price

SELECT DISTINCT p.playerid, p.namefirst, p.namelast, SUM(s.salary) OVER(Partition by p.playerid) AS total_salary
FROM collegeplaying AS c
JOIN people AS p
ON c.playerid = p.playerid
JOIN salaries AS s
ON s.playerid = p.playerid
WHERE c.schoolid = 'vandy'
GROUP BY p.playerid, s.yearid, p.namefirst, p,namelast, s.salary
ORDER BY total_salary DESC;

--Question 4:

SELECT CASE
	WHEN pos IN ('OF') THEN 'Outfield'
	WHEN pos IN ('SS','1B','2B','3B') THEN 'Infield'
	WHEN pos IN ('P','C') THEN 'Battery' END AS positions,
SUM(po)
FROM fielding
WHERE yearid = 2016
GROUP BY positions;
