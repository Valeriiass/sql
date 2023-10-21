USE sales_db;

SELECT * FROM sales_exercise;


#1. Let’s consider store 20. What was the total (rounded) profit of this store?
SELECT #Store,
	   #Dept,
       ROUND(SUM(Weekly_Sales)) as sum_store
FROM sales_exercise
WHERE  Store = 20;  


#2. What was the total profit for department 51 (store 20)?
SELECT #Store,
	   #Dept,
       SUM(Weekly_Sales) as sum_store
FROM sales_exercise
WHERE  Store = 20 AND Dept = 51;


#3. In which week did store 20 achieve a profit record (for the whole store)? How much profit did they make?

SELECT 
	`Date`, 
	ROUND(SUM(weekly_sales), 2)
FROM 
	`sales_exercise` 
WHERE 
	store = 20 
GROUP BY 
	1	#to group by the first column of your result set regardless of what it's called. You can do the same with ORDER BY
ORDER BY 
	SUM(weekly_sales) DESC;


#4. Which was the worst week for store 20 (for the whole store)? How much was the profit?

SELECT 
	`Date`, 
    ROUND(SUM(weekly_sales), 2)
FROM 
	`sales_exercise` 
WHERE 
	store = 20 
GROUP BY 
	1 	#by first column 
ORDER BY 
	SUM(weekly_sales);
    
    

#5. What is the (rounded) average of the weekly sales for store 20 (the whole store)?
SELECT 
	ROUND(SUM(Weekly_Sales) / COUNT(DISTINCT(Date))) avg_weekly_sales		#COUNT(DISTINCT)
FROM 
	`sales_exercise` 
WHERE 
	Store = 20;
    
--
SELECT 
	ROUND(AVG(week_sales)) AS avg_sales
FROM (
	SELECT 
		Store, 
        Date, 
        SUM(weekly_sales) as week_sales
	FROM
		`sales_exercise`
	WHERE
		store = 20
	GROUP BY 
		store, 
        date
	) a;
 
 
#6. What are the 3 stores that have the best historical average of weekly sales?
SELECT Store,
       ROUND(AVG(Weekly_Sales)) as avg_store
FROM sales_exercise
GROUP BY Store 
ORDER BY avg_store DESC
LIMIT 3;

--
SELECT 
	store, 
    AVG(Weekly_Sales)
FROM 
	`sales_exercise`
GROUP BY 
	store
ORDER BY 
	2 DESC;


#7. Which departments from store 20 were the best and the worst in terms of overall sales?
SELECT #Store,
	   Dept,
       ROUND(SUM(Weekly_Sales)) as sum_store
FROM sales_exercise
WHERE STORE = 20
GROUP BY Store, Dept
ORDER BY sum_store DESC
LIMIT 1;  #ASC
-- 

SELECT 
	dept, 
	ROUND(SUM(weekly_sales)) AS total_sales 
FROM 
	`sales_exercise`
WHERE 
	store = 20 
GROUP BY 
	Dept
ORDER BY 
	2 DESC; #ASC
    
    

#8. How much profit does the average department make in store 20?
CREATE TEMPORARY TABLE dep_sales_all
SELECT Store,
			 Dept,
			 ROUND(AVG(Weekly_Sales)) as avg_store,
             ROUND(SUM(Weekly_Sales)) as sum_store
       FROM sales_exercise
       WHERE  Store = 20
       GROUP BY Dept;
       
SELECT 
	ROUND(SUM(Weekly_Sales) / COUNT(DISTINCT(dept)))
from 
	`sales_exercise`
where 
	store = 20;
       
--

WITH meanDept AS (
    SELECT 
		Store, 
		Dept, 
		SUM(Weekly_sales) AS avg_sls 
    FROM 
		`sales_exercise` 
    GROUP BY 
		Store, 
        Dept 
    HAVING 
		Store = 20
    )
SELECT 
	ROUND(AVG(avg_sls)) AS avg_dpt_profit
FROM 
	meanDept;




#9. Consider store 20. Calculate the difference between the total profit of each department and 
#the total profit of the average department. This will be the departments’ “performance metric”.
 #Which department is the worst performer and what’s its performance?
 
 SELECT *,
		(sum_store - avg_store) AS perf_metric
 FROM dep_sales_all
 ORDER BY perf_metric ASC;
 

 
 #10. Which department-store combination is the overall best performer (and what’s its performance?)?
 #Consider the performance metric from the previous question, that is, the difference between 
 #a department’s sales and the sales of the average department of the corresponding store.
 
  SELECT *,
		(sum_store - avg_store) AS perf_metric
 FROM dep_sales_all
 ORDER BY perf_metric DESC;
 
 
 
 
 WITH cte_the_first AS (
	WITH cte_the_second AS(
		SELECT 
			Dept,
			SUM(Weekly_Sales) individual_total
		FROM 
			`sales_exercise`
		WHERE 
			store = 20
		GROUP BY 
			dept
		)
	SELECT 
		Dept, 
        individual_total, 
        (SELECT SUM(individual_total) / COUNT(DISTINCT(Dept)) FROM cte_the_second) all_avg
	FROM 
		cte_the_second
	)
SELECT 
	dept, 
    ROUND((individual_total - all_avg)) AS performance_metric
FROM 
	cte_the_first
ORDER BY 
	performance_metric;

--
WITH avg_dept_sales_store20 AS (
	SELECT 
		AVG(avg_sls) AS avg_20 
	FROM (
		SELECT 
			Store, 
			Dept, 
            SUM(weekly_sales) AS avg_sls 
		FROM 
			`sales_exercise` 
		GROUP BY 
			Store, 
            Dept 
		HAVING 
			Store = 20
		) a
    )
SELECT 
	Store, 
	Dept, 
    SUM(Weekly_sales) AS total_sales,
	ROUND(SUM(Weekly_sales) - (SELECT avg_20 FROM avg_dept_sales_store20), 0) AS performance
FROM 
	`sales_exercise`
WHERE 
	Store = 20
GROUP BY 
	Store, 
    Dept
ORDER BY 
	performance
LIMIT 
	1;



