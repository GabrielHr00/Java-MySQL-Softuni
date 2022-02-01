# 1. 
SELECT first_name, last_name FROM employees
WHERE lower(first_name) LIKE 'sa%'
ORDER BY employee_id;

# 2.
SELECT first_name, last_name FROM employees
WHERE last_name LIKE '%ei%'
ORDER BY employee_id;

# 3. 
SELECT first_name FROM employees
WHERE department_id in (3,10) AND YEAR(hire_date) BETWEEN 1995 and 2005
ORDER BY employee_id;

# 4.
SELECT first_name, last_name FROM employees
WHERE job_title NOT LIKE '%engineer%'
ORDER BY employee_id;


# 5.
SELECT `name` FROM towns
WHERE CHAR_LENGTH(`name`) in (5,6)
ORDER BY `name`;

# 6.
SELECT town_id, `name` FROM towns
WHERE `name` REGEXP '^[MmKkBbEe]'
ORDER BY `name`;

# 7.
SELECT town_id, `name` FROM towns
WHERE `name` REGEXP '^[^RrBbDd]'
ORDER BY `name`;


# 8. 
CREATE VIEW v_employees_hired_after_2000 AS
SELECT first_name, last_name FROM employees
WHERE YEAR(hire_date) > 2000;

SELECT * FROM v_employees_hired_after_2000;

# 9.
SELECT first_name, last_name FROM employees
WHERE CHAR_LENGTH(last_name) = 5;

# 10.
SELECT country_name, iso_code FROM countries
WHERE lower(country_name) LIKE '%a%a%a%'
ORDER BY iso_code;


# 11.
SELECT peak_name, river_name, lower(CONCAT(SUBSTRING(peak_name,1, CHAR_LENGTH(peak_name) - 1), river_name)) AS 'mix' FROM peaks, rivers
WHERE right(lower(peak_name), 1) = left(lower(river_name), 1)
ORDER BY mix;


# 12.
SELECT `name`, DATE_FORMAT(start, '%Y-%m-%d') as 'start' FROM games
WHERE YEAR(start) in (2011, 2012)
ORDER BY start, `name` LIMIT 50;


# 13.
SELECT user_name, SUBSTRING(email, INSTR(email, '@')+1) AS 'email provider' FROM users 
ORDER BY `email provider`, user_name;


# 14.
SELECT user_name, ip_address FROM users
WHERE ip_address LIKE '___.1%.%.___'
ORDER BY user_name;

# 15.
SELECT `name`, 
	CASE 
     WHEN HOUR(start) BETWEEN 0 AND 11 THEN 'Morning'
     WHEN HOUR(start) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
	END AS 'Part of the Day',
    CASE 
     WHEN duration <= 3 THEN 'Extra Short'
     WHEN duration BETWEEN 4 AND 6 THEN 'Short'
     WHEN duration BETWEEN 7 AND 10 THEN 'Long'
     ELSE 'Extra Long'
	END AS 'Duration' FROM games;
    

# 16. 
SELECT product_name, order_date, adddate(order_date, INTERVAL 3 DAY) AS 'pay_due', 
adddate(order_date, INTERVAL 1 MONTH) AS 'deliver_due' FROM orders;

