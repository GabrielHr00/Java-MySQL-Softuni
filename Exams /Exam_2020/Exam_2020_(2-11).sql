# 2.

INSERT INTO products_stores(product_id, store_id)
(SELECT id, 1 
FROM products WHERE id NOT IN (SELECT product_id FROM products_stores)
);

SELECT * FROM products_stores WHERE store_id = 1;

# 3.

UPDATE employees 
SET salary = salary - 500, manager_id = 3
WHERE year(hire_date) > '2003' and store_id NOT IN (14,5);


# 4.
DELETE FROM employees as s 
WHERE manager_id IS NOT NULL AND salary >= 6000;


# 5.
SELECT first_name, middle_name, last_name, salary, hire_date
FROM employees
ORDER BY hire_date DESC;

# 6.
SELECT p.name, p.price, p.best_before, CONCAT(SUBSTRING(p.description, 1,10),'...') as short_description, pi.url
FROM products as p JOIN pictures as pi ON p.picture_id = pi.id
WHERE CHAR_LENGTH(p.description) > 100 AND year(pi.added_on) < 2019 AND p.price > 20
ORDER BY p.price DESC;


# 7. 
SELECT s.name, COUNT(p.id) as product_count, ROUND(AVG(p.price),2) AS avg
FROM stores as s LEFT JOIN products_stores as ps ON s.id = ps.store_id 
LEFT JOIN products as p ON p.id = ps.product_id
GROUP BY s.id
ORDER BY product_count DESC, avg DESC, s.id;


# 8. 
SELECT CONCAT(e.first_name, ' ', e.last_name) as Full_name, s.name as Store_name,
a.name as address, e.salary 
FROM employees as e JOIN stores as s ON s.id = e.store_id JOIN addresses as a
ON a.id = s.address_id
WHERE e.salary < 4000 AND a.name LIKE '%5%' AND CHAR_LENGTH(s.name) > 8 AND e.last_name LIKE '%n';


# 9.
SELECT reverse(s.name) as reversed_name, CONCAT(upper(t.name), '-', a.name) as full_address, COUNT(e.id) as employees_count
FROM employees as e RIGHT JOIN stores as s ON e.store_id = s.id JOIN addresses as a
ON a.id = s.address_id JOIN towns as t ON t.id = a.town_id
GROUP BY s.name
HAVING employees_count > 0
ORDER BY full_address ASC;

USE softuni_stores_system;

# 10.
DROP FUNCTION udf_top_paid_employee_by_store;
DELIMITER %%
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	RETURN (
		SELECT CONCAT(e.first_name, ' ', e.middle_name, '. ', e.last_name, ' works in store for ', FLOOR(DATEDIFF('2020-10-18', e.hire_date)/365), ' years') as full_info 
		FROM employees as e JOIN stores as s ON s.id = e.store_id
		WHERE e.salary = (SELECT MAX(salary) as maxi FROM employees as e1 JOIN stores as s1 ON s1.id = e1.store_id WHERE s1.name = store_name)
	);
END
%% 

SELECT udf_top_paid_employee_by_store('Keylex');
%%

DROP PROCEDURE udp_update_product_price;

%%
# 11.
DELIMITER %% 
CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
BEGIN
	UPDATE products SET price = price + (
		CASE 
			WHEN address_name LIKE '0%' THEN 100
            WHEN address_name NOT LIKE '0%' THEN 200
		END
    );
END
%%

CALL udp_update_product_price('1 Cody Pass');
SELECT name, price FROM products WHERE id = 17;