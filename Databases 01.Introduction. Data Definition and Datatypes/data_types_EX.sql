DROP TABLE minions;
DROP TABLE towns;

CREATE TABLE minions (
	id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(15) NOT NULL,
    age INT
);

CREATE TABLE towns(
	town_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(20)
);

ALTER TABLE towns
CHANGE COLUMN town_id id INT;

ALTER TABLE minions
ADD COLUMN town_id INT;

ALTER TABLE minions
ADD CONSTRAINT fk_k 
FOREIGN KEY minions(town_id) 
REFERENCES towns(id);

ALTER TABLE minions
DROP PRIMARY KEY,
ADD CONSTRAINT
PRIMARY KEY minions(id);

INSERT INTO towns(id, `name`) 
VALUES ("1", "Sofia"),
("2", "Plovdiv"),
("3", "Varna");

INSERT INTO minions(id, `name`, age, town_id) 
VALUES ("1", "Kevin", "22", "1"),
("2", "Bob", "15", "3"),
("3", "Steward", NULL, "2");


TRUNCATE TABLE minions;

DROP TABLE minions;
DROP TABLE towns;

SELECT * FROM minions.minions;


ALTER TABLE users
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users 
PRIMARY KEY users(id, username);


ALTER TABLE users
CHANGE COLUMN `last_login_time` `last_login_time` 
DATE DEFAULT NOW();


CREATE DATABASE movies;
USE movies;

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


CREATE TABLE customers (
	id INT PRIMARY KEY AUTO_INCREMENT, 
    driver_licence_number INT(6),
    full_name VARCHAR(20), 
    address VARCHAR(20), 
    city VARCHAR(20), 
    zip_code INT(4), 
    notes TEXT
);


CREATE TABLE rental_orders (
	id INT,
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


SELECT * FROM towns 
ORDER BY towns.name;

SELECT * FROM departments 
ORDER BY departments.name;

SELECT * FROM employees 
ORDER BY employees.name DESC;