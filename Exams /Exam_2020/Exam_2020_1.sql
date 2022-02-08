-- DROP DATABASE softuni_stores_system;

CREATE DATABASE softuni_stores_system;
USE softuni_stores_system;


CREATE TABLE categories(
	id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE pictures(
	id INT AUTO_INCREMENT PRIMARY KEY,
    url VARCHAR(100) not null,
    added_on DATETIME NOT NULL
);

CREATE TABLE towns(
	id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(20) NOT NULL UNIQUE
);


CREATE TABLE addresses(
	id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(50) NOT NULL UNIQUE,
	town_id INT NOT NULL,
    CONSTRAINT fk_tw_id
    FOREIGN KEY (town_id)
    REFERENCES towns(id)
);

CREATE TABLE stores(
	id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(20) NOT NULL UNIQUE,
    rating FLOAT NOT NULL,
    has_parking TINYINT DEFAULT FALSE,
    address_id INT NOT NULL,
    CONSTRAINT fk_addr
    FOREIGN KEY (address_id)
    REFERENCES addresses(id)
);

CREATE TABLE employees(
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    middle_name VARCHAR(1),
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19,2) NOT NULL DEFAULT 0,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT NOT NULL,
    CONSTRAINT fk_empl
    FOREIGN KEY (manager_id)
    REFERENCES employees(id),
    CONSTRAINT fk_store
    FOREIGN KEY (store_id)
    REFERENCES stores(id)
);

CREATE TABLE products(
	id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10,2) not null,
    description TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    CONSTRAINT fk_cat
    FOREIGN KEY (category_id)
    REFERENCES categories(id),
    CONSTRAINT fk_pic
    FOREIGN KEY (picture_id)
    REFERENCES pictures(id)
);

CREATE TABLE products_stores(
	product_id INT NOT NULL,
    store_id INT NOT NULL,
    CONSTRAINT fk_pro
    FOREIGN KEY (product_id)
    REFERENCES products(id),
    CONSTRAINT fk_stor
    FOREIGN KEY (store_id)
    REFERENCES stores(id),
    CONSTRAINT pk_pri
    PRIMARY KEY (product_id, store_id)
);






