# 6.
DROP TABLE people;

CREATE TABLE people (
	id INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(10,2),
    weight DOUBLE(10,2),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
	biography TEXT
);


INSERT INTO people(`name`, height, weight, gender, birthdate, biography)
VALUES('pencho', '1.65', '67', 'm', '1996-12-03', 'dsafasfdsa'),
('az', 1.55, 63, 'f', '1996-12-03', 'dsafasfdsa'),
('sum', 1.75, 54, 'm', '1996-12-03', 'dsafasfdsa'),
('tuk', 1.75, 54, 'f', '1996-12-03', 'dsafasfdsa'),
('iaz', 1.75, 54, 'm', '1996-12-03', 'dsafasfdsa');

# 7. 

CREATE TABLE users(
	id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) NOT NULL,
    `password` VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time TIMESTAMP,
    is_deleted BOOLEAN
);

INSERT INTO users(`username`, `password`)
VALUES('pencho', '123'),
('az', '3435'),
('az', '3435'),
('az', '3435'),
('az', '3435');

# 9. 

ALTER TABLE users
CHANGE COLUMN last_login_time last_login_time
TIMESTAMP DEFAULT NOW();


# 10.
ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT PRIMARY KEY users(id),
ADD CONSTRAINT UNIQUE users(username);

# 11. 

CREATE DATABASE Movies;
USE Movies;

CREATE TABLE directors(
	id INT PRIMARY KEY AUTO_INCREMENT,
    director_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO directors(director_name)
VALUES('pencho'),
('az'),
('az'),
('az'),
('az');

CREATE TABLE genres(
	id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO genres(genre_name)
VALUES('pencho'),
('az'),
('az'),
('az'),
('az');


CREATE TABLE categories(
	id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    notes TEXT
);

INSERT INTO categories(category_name)
VALUES('pencho'),
('az'),
('az'),
('az'),
('az');

CREATE TABLE movies(
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    director_id INT,
    copyright_year INT,
    `length` DOUBLE,
    genre_id INT, 
    category_id INT, 
    rating DOUBLE,
    notes TEXT
);

INSERT INTO movies(title)
VALUES('pencho'),
('az'),
('az'),
('az'),
('az');



INSERT INTO towns(`name`)
VALUES ('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO departments(`name`)
VALUES ('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');

INSERT INTO employees(first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', '4', '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', '1', '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', '5', '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', '2', '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', '3', '2016-08-28', 599.88);


# 15.

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees; 


# 17.

SELECT name FROM towns 
ORDER BY towns.name;

SELECT name FROM departments 
ORDER BY departments.name;

SELECT first_name, last_name, job_title, salary FROM employees 
ORDER BY employees.salary DESC;

# 18.

UPDATE employees
SET salary = salary*1.1;

SELECT salary FROM employees;


# 12. 
CREATE TABLE categories (
	id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(30) NOT NULL,
    daily_rate DOUBLE,
    weekly_rate DOUBLE,
    monthly_rate DOUBLE,
    weekend_rate DOUBLE
);

INSERT INTO categories(category)
VALUES 
('action'),
('drama'),
('comedy');


CREATE TABLE cars(
	id INT PRIMARY KEY AUTO_INCREMENT,
    plate_number VARCHAR(10) NOT NULL,
    make DATE, 
    model VARCHAR(30) NOT NULL,
    car_year YEAR,
    category_id INT,
    doors INT, 
    picture BLOB, 
    car_condition TEXT,
    available BOOLEAN,
    CONSTRAINT fk_cars_category 
	FOREIGN KEY cars(id) REFERENCES categories(id)
);

INSERT INTO categories(plate_number, model)
VALUES 
('FASDAF', 'OPEL'),
('FASDFASFD', 'OPEL'),
('FASFASF', 'SKODA');

CREATE TABLE employees (	
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30),
    last_name VARCHAR(20),
    title VARCHAR(20), 
    notes TEXT
);

INSERT INTO employees(first_name, last_name)
VALUES 
('FASDAF', 'OPEL'),
('FASDFASFD', 'OPEL'),
('FASFASF', 'SKODA');

CREATE TABLE customers (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    driver_licence_number INT(6),
    full_name VARCHAR(20), 
    address VARCHAR(20), 
    city VARCHAR(20), 
    zip_code INT(4), 
    notes TEXT
);

INSERT INTO customers(driver_licence_number, full_name)
VALUES 
('123145', 'OPEL'),
('123145', 'OPEL'),
('123145', 'SKODA');


CREATE TABLE rental_orders (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT, 
    customer_id INT, 
    car_id INT,
    car_condition TEXT, 
    tank_level INT, 
    kilometrage_start INT,
    kilometrage_end INT, 
    total_kilometrage INT, 
    start_date DATETIME, 
    end_date DATETIME, 
    total_days INT, 
    rate_applied DOUBLE, 
    tax_rate DOUBLE, 
    order_status BOOLEAN, 
    notes TEXT,
    CONSTRAINT fk_rental_orders_employee FOREIGN KEY rental_orders(employee_id) REFERENCES employees(id),
    CONSTRAINT fk_rental_orders_customer FOREIGN KEY rental_orders(customer_id) REFERENCES customers(id),
    CONSTRAINT fk_rental_orders_cars FOREIGN KEY rental_orders(car_id) REFERENCES cars(id)
);

INSERT INTO rental_orders(employee_id, customer_id, car_id)
VALUES (3, 2, 1),
(2, 1, 2),
(1, 3, 3);

