CREATE DATABASE stc;
USE stc;

CREATE TABLE addresses(
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(100) NOT NULL
);

CREATE TABLE clients(
	id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers(
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating FLOAT DEFAULT 5.5
);

CREATE TABLE categories(
	id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(10) NOT NULL
);

CREATE TABLE cars(
	id INT AUTO_INCREMENT PRIMARY KEY,
	make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_cate
	FOREIGN KEY (category_id)
    REFERENCES categories(id)
);

CREATE TABLE courses(
	id INT AUTO_INCREMENT PRIMARY KEY,
	from_address_id INT NOT NULL,
    start DATETIME NOT NULL,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    bill DECIMAL(10,2) DEFAULT 10,
    CONSTRAINT fk_adr
    FOREIGN KEY (from_address_id)
    REFERENCES addresses(id),
    CONSTRAINT fk_car
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    CONSTRAINT fk_client
    FOREIGN KEY (client_id)
    REFERENCES clients(id)
);


CREATE TABLE cars_drivers(
	car_id INT NOT NULL,
    driver_id INT NOT NULL,
    CONSTRAINT fk_car_dr
    FOREIGN KEY (car_id)
    REFERENCES cars(id),
    CONSTRAINT fk_driver_car
    FOREIGN KEY (driver_id)
    REFERENCES drivers(id),
    CONSTRAINT pk_dr_cr
    PRIMARY KEY(car_id, driver_id)
);