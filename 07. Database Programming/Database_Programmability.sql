# 1.

DELIMITER **
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE c INT;
    SET c := (SELECT COUNT(*) 
        FROM towns as t LEFT JOIN addresses as a ON t.address_id = a.address_id 
        LEFT JOIN employees as e ON e.address.id = a.address_id
        WHERE t.name = town_name);
	return c;
END
**



# 2.
DELIMITER ###
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
	UPDATE employees AS e RIGHT JOIN department as d
    ON d.department_id = e.department_id
	SET e.salary = e.salary*1.05
	WHERE d.name = department_name;
END
###



# 3.
DELIMITER ))
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
	UPDATE employees as e
    SET e.salary = e.salary*1.05
	WHERE e.employee_id = id;
END
))

-- SELECT salary FROM employees where employee_id = 17;

-- CALL usp_raise_salary_by_id(17);


# 4.
-- DROP TABLE deleted_employees;
CREATE TABLE deleted_employees(
	`employee_id` int(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`first_name` varchar(50) NOT NULL,
	`last_name` varchar(50) NOT NULL,
	`middle_name` varchar(50) DEFAULT NULL,
	`job_title` varchar(50) NOT NULL,
	`department_id` int(10) NOT NULL,
	`salary` decimal(19,4) NOT NULL
);
CREATE TRIGGER trigger_employee AFTER DELETE 
ON employees
	FOR EACH ROW
    BEGIN
		INSERT INTO deleted_employees(first_name,last_name,middle_name,job_title,department_id,salary) 
		VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
	END
    
DELETE FROM employees WHERE employee_id in (1);

SELECT * FROM deleted_employees;