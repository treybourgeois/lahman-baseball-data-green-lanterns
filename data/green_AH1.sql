SELECT *
FROM batting;

--Question 5. 
/*SELECT CASE 
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
FROM batting) Sub
GROUP BY decades
ORDER BY decades */ ---- strikeouts and homeruns seem to have linear relationship


--Q.6- Find by percentage if need be

SELECT playerid, (SUM(SB)*100)/SUM((SB + CS)  AS stolenbase
FROM batting
WHERE yearid = '2016' 
GROUP BY playerid 
HAVING SUM(SB + CS) >= 20
ORDER BY stolenbase DESC;
