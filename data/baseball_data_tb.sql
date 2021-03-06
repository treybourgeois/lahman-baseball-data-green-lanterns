/*SELECT COUNT (DISTINCT year)
FROM homegames; -- 1.) 146 Years

SELECT MIN(year) AS first_year, MAX(year) AS last_year
FROM homegames; -- 1.) 1871 - 2016 */ -- QUESTION 1

SELECT namefirst, namelast, height
FROM people
ORDER BY height ASC; -- Eddie Gradel is shortest player -- Height = 43


SELECT span_first, span_last
FROM homegames;
