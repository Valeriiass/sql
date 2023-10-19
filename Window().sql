#WINDOW FUNCTION 
USE publications;  
    
SELECT *
FROM sales
ORDER BY ord_date;

# quantity of units of each order
SELECT 
	ord_num,
    sum(qty) AS total_qty
FROM
    sales
GROUP BY
    ord_num;
 
#Window function with total qty of orders
SELECT
    *,
    SUM(qty) OVER (PARTITION BY ord_num) AS order_sales   #PARTITION BY clause = ORDER BY clause  
FROM sales
ORDER BY ord_date;



SELECT
    *,
    SUM(qty) OVER (ORDER BY ord_date) AS cum_sales 	#OVER is an indicator
FROM sales;
#here the order by cum_sales ASC.  by all the other rows with a preceding order date


#combine
SELECT
    *,
    YEAR(ord_date), #new column 
    SUM(qty) OVER (PARTITION BY YEAR(ord_date) ORDER BY ord_date) AS year_sales
FROM
    sales;
#the order by years and inside by qty ASC


#the relevant columns togetherSELECT
SELECT 
    ord_num,
    ord_date,
    qty,
    SUM(qty) OVER (PARTITION BY ord_date) AS daily_sales,  #sum in each order 
    SUM(qty) OVER (ORDER BY ord_date) AS cum_sales,			#cumulation all orders in ASC
    SUM(qty) OVER (PARTITION BY YEAR(ord_date) ORDER BY ord_date) AS cum_year_sales
FROM sales;
#GROUP BY modifies the entire query
#PARTITION BY just works on a window function, like ROW_NUMBER()

#COUNT in Window function 
SELECT
    ord_num,
    title_id,
    qty,
    COUNT(title_id) OVER (PARTITION BY ord_num) AS titles_in_order
FROM sales
ORDER BY ord_date;  #only for order by date


#AVR in Window function
SELECT
    ord_num,
    title_id,
    qty,
    AVG(qty) OVER (PARTITION BY ord_num) AS avg_qty_by_order
FROM sales
ORDER BY ord_date;


#ROW_NUMBER()
SELECT
    ord_num,
    ord_date,
    ROW_NUMBER() OVER (ORDER BY ord_date) AS row_num
FROM sales;


SELECT
    ord_num,
    ord_date,
    ROW_NUMBER() OVER (PARTITION BY YEAR(ord_date) ORDER BY ord_date) AS row_num_year
FROM sales;

#RANK()
SELECT
    ord_num,
    ord_date,
    RANK() OVER (PARTITION BY YEAR(ord_date) ORDER BY ord_date) AS row_rank_year
FROM sales;


SELECT
    ord_num,
    ord_date,
    RANK() OVER (PARTITION BY YEAR(ord_date) ORDER BY ord_date, ord_num) AS row_rank_year
FROM sales;

SELECT
    ord_num,
    ord_date,
    RANK() OVER (ORDER BY ord_date, ord_num) AS row_rank_year #without PARTITION BY will counting by order each row
FROM sales;


SELECT
    ord_num,
    ord_date,
    DENSE_RANK() OVER (ORDER BY ord_date, ord_num) AS row_rank_year   #DENSE_RANK(to avoid counting by order each row)
FROM sales;