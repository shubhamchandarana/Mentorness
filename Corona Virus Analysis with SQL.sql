
-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values

SELECT Province,Latitude,Date,Confirmed,Deaths,Recovered  FROM [POWERBI].[dbo].['Corona Virus Dataset$'] WHERE Province IS NULL 

 
--so there are no null values are present

--Q2. If NULL values are present, update them with zeros for all columns. 
 UPDATE [POWERBI].[dbo].['Corona Virus Dataset$']
SET Province =0
WHERE Province IS NULL;
--No changes
-- Q3. check total number of rows
select count(*) from [POWERBI].[dbo].['Corona Virus Dataset$']

-- Q4. Check what is start_date and end_date

SELECT MIN(Date) AS first_date
from [POWERBI].[dbo].['Corona Virus Dataset$'];


SELECT MAX(Date) AS last_date
 from [POWERBI].[dbo].['Corona Virus Dataset$'];


-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT MONTH(Date)) AS num_months
 from [POWERBI].[dbo].['Corona Virus Dataset$'];

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    AVG(Confirmed) AS avg_confirmed,
    AVG(Deaths) AS avg_deaths,
    AVG(Recovered) AS avg_recovered
FROM 
   
    [POWERBI].[dbo].['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    month,
    MAX(confirmed_mode) AS most_frequent_confirmed,
    MAX(deaths_mode) AS most_frequent_deaths,
    MAX(recovered_mode) AS most_frequent_recovered
FROM (
    SELECT 
        MONTH(date) AS month,
        confirmed AS confirmed_mode,
        deaths AS deaths_mode,
        recovered AS recovered_mode,
        ROW_NUMBER() OVER (PARTITION BY MONTH(date) ORDER BY COUNT(*) DESC) AS rn
    FROM 
        [POWERBI].[dbo].['Corona Virus Dataset$']
    GROUP BY 
        MONTH(date), confirmed, deaths, recovered
) AS monthly_stats
WHERE rn = 1
GROUP BY 
    month
ORDER BY 
    month;


-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS year,
    MIN(CASE WHEN confirmed > 0 THEN confirmed ELSE NULL END) AS min_confirmed,
    MIN(CASE WHEN deaths > 0 THEN deaths ELSE NULL END) AS min_deaths,
    MIN(CASE WHEN recovered > 0 THEN recovered ELSE NULL END) AS min_recovered
FROM 
   ['Corona Virus Dataset$']
GROUP BY 
    YEAR(Date);

-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS year,
    MAX(confirmed) AS max_confirmed,
    MAX(deaths) AS max_deaths,
    MAX(recovered) AS max_recovered

FROM 
   ['Corona Virus Dataset$']
GROUP BY 
    YEAR(Date);


-- Q10. The total number of case of confirmed, deaths, recovered each 
SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    SUM(confirmed) AS total_confirmed,
    SUM(deaths) AS total_deaths,
    SUM(recovered) AS total_recovered

FROM 
   ['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV)
---In SQL Server, there isn't a built-in VARIANCE
SELECT 
    SUM(Confirmed) AS total_confirmed_cases
FROM 
       ['Corona Virus Dataset$'];

SELECT 
    AVG(Confirmed) AS average_confirmed_cases
FROM 
       ['Corona Virus Dataset$'];

SELECT 
    AVG(CONVERT(FLOAT, confirmed) * CONVERT(FLOAT, confirmed)) - AVG(confirmed) * AVG(confirmed) AS variance_confirmed_cases
FROM 
    ['Corona Virus Dataset$'];

SELECT 
    STDEV(confirmed) AS stdev_confirmed_cases
FROM 
       ['Corona Virus Dataset$'];

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    SUM(Deaths) AS total_death_cases
FROM 
    ['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');
SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    AVG(deaths) AS average_death_cases
FROM 
      ['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');
SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    VAR(deaths) AS variance_death_cases
FROM 
     ['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');
SELECT 
    FORMAT(Date, 'yyyy-MM') AS month,
    STDEV(deaths) AS stdev_death_cases
FROM 
      ['Corona Virus Dataset$']
GROUP BY 
    FORMAT(Date, 'yyyy-MM');

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    SUM(recovered) AS total_recovered_cases
FROM 
    ['Corona Virus Dataset$'];
SELECT 
    AVG(recovered) AS average_recovered_cases
FROM 
     ['Corona Virus Dataset$'];
SELECT 
    VAR(recovered) AS variance_recovered_cases
FROM 
    ['Corona Virus Dataset$'];
SELECT 
    STDEV(recovered) AS stdev_recovered_cases
FROM 
     ['Corona Virus Dataset$'];


-- Q14. Find Country having highest number of the Confirmed case

SELECT [Country/Region]
FROM ['Corona Virus Dataset$']
WHERE confirmed = (
    SELECT MAX(Confirmed) FROM ['Corona Virus Dataset$']
);


-- Q15. Find Country having lowest number of the death case

SELECT [Country/Region]
FROM ['Corona Virus Dataset$']
WHERE Deaths = (
    SELECT MIN(Deaths) FROM ['Corona Virus Dataset$']
);


-- Q16. Find top 5 countries having highest recovered case

SELECT [Country/Region], Recovered
FROM (
    SELECT 
        Recovered, 
        [Country/Region],
        ROW_NUMBER() OVER (ORDER BY recovered DESC) AS rank
    FROM ['Corona Virus Dataset$']
) AS ranked_countries
WHERE rank <= 5;



