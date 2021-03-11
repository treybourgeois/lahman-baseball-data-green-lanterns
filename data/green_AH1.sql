SELECT *
FROM batting;

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


