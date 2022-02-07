# 2.

INSERT INTO clients(full_name, phone_number) 
(SELECT CONCAT(first_name, ' ', last_name), CONCAT('(088) 9999', id + id) FROM drivers WHERE id BETWEEN 10 AND 20);


# 3.

UPDATE cars
SET `condition` = 'C'
WHERE (mileage >= 800000 OR mileage IS NULL) AND year <= 2010 AND make != ' Mercedes-Benz';


# 4.

DELETE FROM clients
WHERE CHAR_LENGTH(full_name) > 3 AND id NOT IN (SELECT client_id FROM courses);


# 5.

SELECT make, model, `condition` FROM cars as c
ORDER BY c.id;


# 6.
SELECT d.first_name, d.last_name, c.make, c.model, c.mileage
FROM drivers as d JOIN cars_drivers as dc ON d.id = dc.driver_id JOIN cars as c ON c.id = dc.car_id
WHERE c.mileage IS NOT NULL
ORDER BY c.mileage DESC, d.first_name ASC;


# 7.

SELECT c.id as car_id, c.make, c.mileage, COUNT(co.id) as count_of_courses, ROUND(AVG(co.bill),2) as avg_bill
FROM cars as c LEFT JOIN courses as co ON c.id = co.car_id
GROUP BY c.id 
HAVING count_of_courses != 2
ORDER BY count_of_courses DESC, car_id ASC;


# 8.

SELECT cl.full_name, COUNT(c.id) as count_of_cars, SUM(co.bill) as total_sum
FROM clients as cl LEFT JOIN courses as co ON cl.id = co.client_id LEFT JOIN cars as c ON co.car_id = c.id
GROUP BY cl.full_name
HAVING full_name LIKE '_a%' AND count_of_cars > 1
ORDER BY full_name;

# 9.

SELECT a.name, 
	CASE 
		WHEN HOUR(co.start) BETWEEN 6 AND 20 THEN 'Day'
        ELSE 'Night' 
	END AS 'day_time',
    co.bill,
    cl.full_name,
    c.make,
    c.model,
    cat.name
FROM addresses as a LEFT JOIN courses as co ON a.id = co.from_address_id 
LEFT JOIN clienTs as cl ON cl.id = co.client_id 
JOIN cars as c ON c.id = co.car_id JOIN categories as cat ON cat.id = c.category_id
ORDER BY co.id;


# 10.
DELIMITER %%
CREATE FUNCTION udf_courses_by_client(phone_num VARCHAR(20))
RETURNS INT 
DETERMINISTIC
BEGIN
	RETURN (SELECT COUNT(co.id)
    FROM clients as cl LEFT JOIN courses as co ON cl.id = co.client_id
    WHERE cl.phone_number = phone_num);
END
%%


# 11.
DELIMITER %%
CREATE PROCEDURE udp_courses_by_address(address_name VARCHAR(100))
BEGIN
	SELECT a.name, cl.full_name, 
	CASE
		WHEN co.bill <= 20 THEN 'Low'
        WHEN co.bill <= 30 THEN 'Medium'
        ELSE 'High'
	END as level_of_bill,
    c.make,
    c.condition,
    cat.name
	FROM addresses as a LEFT JOIN courses as co ON a.id = co.from_address_id 
	LEFT JOIN clients as cl ON cl.id = co.client_id 
	JOIN cars as c ON c.id = co.car_id JOIN categories as cat ON cat.id = c.category_id
	WHERE a.name = address_name
	ORDER BY c.make, cl.full_name;
END
%%