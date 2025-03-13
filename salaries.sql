-- create database CASESTUDY;

USE CASESTUDY;

-- load the datasets using infile methods 
LOAD DATA INFILE 'R://case study//salaries.csv'
INTO TABLE salaries
FIELDS TERMINATED BY ','        -- Use a comma if your file is CSV
ENCLOSED BY '"'                 -- Optional: used if values are enclosed by quotes
LINES TERMINATED BY '\n'        -- Line ending
IGNORE 1 LINES;                  -- Skip the header row

-- see the total number of 
select count(*) as 'total_count' from salaries;


/*1.You're a Compensation analyst employed by a multinational corporation. Your Assignment is to Pinpoint Countries who give work fully 
remotely, for the title 'managers’ Paying salaries Exceeding $90,000 USD*/
SELECT distINct(company_locatiON) FROM salaries WHERE job_title like '%Manager%' and salary_IN_usd > 90000 and remote_ratio= 100;



/*2.AS a remote work advocate Working for a progressive HR tech startup who place their freshers’ clients IN large tech firms.
 you're tasked WITH Identifying top 5 Country Having  greatest count of large(company size) number of companies.*/
SELECT company_locatiON, COUNT(company_size) AS 'cnt' 
FROM (
    SELECT * FROM salaries WHERE experience_level ='EN' AND company_size='L'
) AS t  
GROUP BY company_locatiON 
ORDER BY cnt DESC
LIMIT 5;


/*3. Picture yourself AS a data scientist Working for a workforce management platform. Your objective is to calculate the percentage of 
employees. Who enjoy fully remote roles WITH salaries Exceeding $100,000 USD, Shedding light ON the attractiveness of high-paying remote 
positions IN today's job market.*/

set @COUNT= (SELECT COUNT(*) FROM salaries  WHERE salary_IN_usd >100000 and remote_ratio=100);
set @total = (SELECT COUNT(*) FROM salaries where salary_in_usd>100000);
set @percentage= round((((SELECT @COUNT)/(SELECT @total))*100),2);
SELECT @percentage AS '%  of people workINg remotly and havINg salary >100,000 USD';



/*4.	Imagine you're a data analyst Working for a global recruitment agency. Your Task is to identify the Locations where entry-level 
average salaries exceed the average salary for that job title in market for entry level, helping your agency guide candidates towards 
lucrative countries.*/

SELECT company_locatiON, t.job_title, average_per_country, average FROM 
(
	SELECT company_locatiON,job_title,AVG(salary_IN_usd) AS average_per_country FROM  salaries WHERE experience_level = 'EN' 
	GROUP BY  company_locatiON, job_title
) AS t 
INNER JOIN 
( 
	 SELECT job_title,AVG(salary_IN_usd) AS average FROM  salaries  WHERE experience_level = 'EN'  GROUP BY job_title
) AS p 
ON  t.job_title = p.job_title WHERE average_per_country> average;
    

-- find how many jons are there in job_title that exceeds the greater than averages 
select job_title, count(*) as 'no_of_jobs' from (
SELECT company_locatiON, t.job_title, average_per_country, average FROM 
(
	SELECT company_locatiON,job_title,AVG(salary_IN_usd) AS average_per_country FROM  salaries WHERE experience_level = 'EN' 
	GROUP BY  company_locatiON, job_title
) AS t 
INNER JOIN 
( 
	 SELECT job_title,AVG(salary_IN_usd) AS average FROM  salaries  WHERE experience_level = 'EN'  GROUP BY job_title
) AS p 
ON  t.job_title = p.job_title WHERE average_per_country> average
)s group by job_title order by no_of_jobs desc;


/*5. You've been hired by a big HR Consultancy to look at how much people get paid IN different Countries. Your job is to Find out for
 each job title which Country pays the maximum average salary. This helps you to place your candidates IN those countries.*/

SELECT company_locatiON , job_title , average FROM
(
SELECT *, dense_rank() over (partitiON by job_title order by average desc)  AS num FROM 
(
SELECT company_locatiON , job_title , AVG(salary_IN_usd) AS 'average' FROM salaries GROUP BY company_locatiON, job_title
)k
)t  WHERE num=1













































