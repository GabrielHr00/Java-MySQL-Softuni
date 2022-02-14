USE online_store;


# 2.
INSERT INTO reviews(content, picture_url, published_at, rating)
(SELECT SUBSTRING(description,1,15), reverse(name), '2010-10-10', (price*8) FROM products WHERE id >= 5);

# 3.
UPDATE products 
SET quantity_in_stock = quantity_in_stock - 5
WHERE quantity_in_stock >= 60 AND quantity_in_stock <= 70;

# 4.
DELETE FROM customers 
WHERE id NOT IN (SELECT customer_id FROM orders);

SELECT * FROM orders;


# 5.
SELECT id, name
FROM categories 
ORDER BY name DESC;


# 6.
SELECT id, brand_id, name, quantity_in_stock
FROM products 
WHERE price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock ASC, id ASC;


# 7.
SELECT id, content, rating, picture_url, published_at
FROM reviews
WHERE content LIKE 'My%' AND CHAR_LENGTH(content) > 61
ORDER BY rating DESC;


# 8.
SELECT CONCAT(c.first_name, ' ', c.last_name) as full_name, c.address, o.order_datetime
FROM customers as c JOIN orders as o ON c.id = o.customer_id
WHERE YEAR(order_datetime) <= 2018
ORDER BY full_name DESC;

# 9.
SELECT COUNT(p.id) AS items_count, c.name, SUM(p.quantity_in_stock) as total_quantity
FROM categories as c JOIN products as p ON c.id = p.category_id
GROUP BY c.name
ORDER BY items_count DESC, total_quantity ASC LIMIT 5;

# 10.
DROP FUNCTION udf_customer_products_count;
DELIMITER %%
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN
	RETURN (
		SELECT COUNT(p.id)
        FROM customers as c JOIN orders as o on c.id = o.customer_id
        JOIN orders_products as op ON op.order_id = o.id
        JOIN products as p ON p.id = op.product_id
		WHERE c.first_name = name
        GROUP BY c.id
    );
END 
%%


SELECT c.first_name,c.last_name, udf_customer_products_count('Shirley') as `total_products` FROM customers c
WHERE c.first_name = 'Shirley';

# 11.
DELIMITER %%
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
	UPDATE products as p
    SET p.price = p.price - (p.price * 0.3)
    WHERE p.category_id = (SELECT id FROM categories WHERE category_name = name) AND (SELECT rating FROM reviews WHERE p.review_id = id) < 4;
END 
%%

%%
DROP PROCEDURE udp_reduce_price;

%%
DELIMITER %%
CREATE PROCEDURE udp_reduce_price(category_name VARCHAR(50))
BEGIN
	UPDATE products as p JOIN categories as c ON p.category_id = c.id JOIN reviews as r ON p.review_id = r.id
    SET p.price = p.price - (p.price * 0.3)
    WHERE category_name = c.name AND r.rating < 4;
END 
%%


CALL udp_reduce_price ('Phones and tablets');

%%
# 2.
INSERT INTO reviews(content, rating, picture_url, published_at)
(SELECT SUBSTRING(description, 1, 15), (price/8), reverse(name), '2010-10-10' FROM products WHERE id >= 5);

