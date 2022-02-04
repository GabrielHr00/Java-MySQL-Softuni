# 1.

SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) as 'full_name', d.department_id, d.`name` AS 'department_name' 
FROM employees as e RIGHT JOIN departments as d ON e.employee_id = d.manager_id
ORDER BY `employee_id` LIMIT 5;

# 2.

SELECT t.town_id, t.name AS 'town_name', a.address_text
FROM towns as t RIGHT JOIN addresses as a ON t.town_id = a.town_id
WHERE t.town_id in ('32', '9', '15')
ORDER BY t.town_id, a.address_id;

# 3.
SELECT e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
FROM employees as e
WHERE e.manager_id IS NULL
ORDER BY e.employee_id;

# 4.
SELECT COUNT(*) as 'count' 
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);