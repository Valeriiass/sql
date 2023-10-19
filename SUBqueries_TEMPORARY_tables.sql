USE magist;


SELECT * FROM product_category_name_translation;
SELECT * FROM products;


SELECT order_id, payment_type, payment_value
FROM order_payments 
WHERE payment_type = ('credit_card') AND payment_value > 1000;



SELECT order_id, order_status, order_purchase_timestamp
FROM orders
WHERE order_status='delivered' AND order_purchase_timestamp LIKE '2018%';



CREATE TEMPORARY TABLE health_per 
SELECT product_id, product_category_name_english 
FROM products p
INNER JOIN product_category_name_translation cat
ON p.product_category_name = cat.product_category_name
WHERE product_category_name_english = 'health_beauty' OR  product_category_name_english = 'perfumery';




#SUB
#CREATE TEMPORARY TABLE time and money
CREATE TEMPORARY TABLE payment_id
SELECT order_id, order_status, order_purchase_timestamp, payment_type, payment_value
FROM (SELECT o.order_id, o.order_status, o.order_purchase_timestamp, sub.payment_value, sub.payment_type
		FROM orders o
        INNER JOIN (SELECT order_id, payment_type, payment_value
					FROM order_payments 
					WHERE payment_type = ('credit_card') AND payment_value > 1000)  as sub
        ON o.order_id = sub.order_id
        WHERE o.order_status='delivered' AND o.order_purchase_timestamp LIKE '2018%') as hi;
        
        
SELECT * FROM payment_id;



#CREATING A TEMPORARY CATEGORY TABLE 
CREATE TEMPORARY TABLE cat_id
SELECT gg.product_id, gg.product_category_name_english, oi.order_id
FROM (SELECT product_id, product_category_name_english 
	FROM products p
	INNER JOIN product_category_name_translation cat
	ON p.product_category_name = cat.product_category_name
	WHERE product_category_name_english = 'health_beauty' OR  product_category_name_english = 'perfumery') as gg
INNER JOIN order_items oi
ON gg.product_id = oi.product_id
;

SELECT * FROM cat_id;



SELECT *
FROM payment_id pi
INNER JOIN cat_id ci
ON pi.order_id = ci.order_id;

                            

