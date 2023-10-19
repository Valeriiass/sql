#CHALLENGE 

USE magist;

SELECT 
	order_id, 
	product_id, 
	price, 
	ROUND(SUM(price) OVER (PARTITION BY order_id)) AS total_order_price,
    COUNT(product_id) OVER (PARTITION BY order_id) AS no_of_products
FROM order_items 
WHERE shipping_limit_date <= '2016-10-09 00:00:00';



#CATEGORY TABLE 
CREATE TEMPORARY TABLE category_table
SELECT gg.product_id, gg.product_category_name_english, oi.order_id
FROM (SELECT product_id, product_category_name_english 
	FROM products p
	INNER JOIN product_category_name_translation cat
	ON p.product_category_name = cat.product_category_name) as gg
	#WHERE product_category_name_english = 'health_beauty' OR  product_category_name_english = 'perfumery') as gg
INNER JOIN order_items oi
ON gg.product_id = oi.product_id
;

SELECT * FROM category_table;


SELECT 
	oi.product_id, 
    product_category_name_english,
    #round((sum(price),2) OVER (PARTITION BY order_id))
    ROUND(SUM(price) OVER (PARTITION BY product_category_name_english)) AS category_total_sales,
    # AS category_ENG,
    ROUND(AVG(price) OVER (PARTITION BY product_category_name_english),2) AS avg_category_payment   #ROUND() function in window -> ROUND(AGG(column) OVER ((PARTITION BY column_2), 2)
	FROM order_items oi
		JOIN orders o
			ON oi.order_id = o.order_id
		JOIN category_table ct
			ON oi.product_id = ct.product_id
    WHERE shipping_limit_date LIKE '2016-10-09%' AND  order_status = 'delivered'
    ORDER BY category_total_sales DESC;

