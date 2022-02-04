# 1.
CREATE TABLE people(
	person_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    first_name VARCHAR(30) NOT NULL,
	salary DECIMAL(10,2) NOT NULL DEFAULT 0,
    passport_id INT NOT NULL UNIQUE
);

CREATE TABLE passports(
	passport_id INT AUTO_INCREMENT NOT NULL UNIQUE,
	passport_number VARCHAR(8) NOT NULL UNIQUE
) AUTO_INCREMENT = 101;

ALTER TABLE people 
ADD CONSTRAINT pk_id PRIMARY KEY people(person_id),
ADD CONSTRAINT fk_pass_id FOREIGN KEY (passport_id)
REFERENCES passports(passport_id);

INSERT INTO passports(passport_number) 
VALUES ('N34FG21B'),
('K65LO4R7'),
('ZE657QP2');

INSERT INTO people(first_name, salary, passport_id)
VALUES ('Roberto', '43300.00', 102),
('Tom', '56100.00', '103'),
('Yana', '60200.00', '101');



# 2.
CREATE TABLE manufacturers(
	manufacturer_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    `name` VARCHAR(40) NOT NULL,
    established_on DATE NOT NULL
);
DROP TABLE models;
CREATE TABLE models(
	model_id INT AUTO_INCREMENT UNIQUE NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    manufacturer_id INT NOT NULL
) AUTO_INCREMENT = 101;

INSERT INTO manufacturers(`name`, established_on) 
VALUES ('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');


INSERT INTO models(`name`, manufacturer_id)
VALUES ('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3);

ALTER TABLE manufacturers
ADD CONSTRAINT pk_manufac
PRIMARY KEY (manufacturer_id);

ALTER TABLE models
ADD CONSTRAINT pk_model_id PRIMARY KEY (model_id),
ADD CONSTRAINT fk_manufacturer_id FOREIGN KEY (manufacturer_id) 
REFERENCES manufacturers(manufacturer_id);



# 3.
CREATE TABLE exams(
	exam_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    `name` VARCHAR(20) NOT NULL
) AUTO_INCREMENT = 101;

CREATE TABLE students(
	student_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(20) NOT NULL
);

CREATE TABLE students_exams(
	student_id INT NOT NULL,
	exam_id INT NOT NULL,
    CONSTRAINT fk_stud FOREIGN KEY (student_id)
    REFERENCES students(student_id),
    CONSTRAINT fk_exam FOREIGN KEY (exam_id)
    REFERENCES exams(exam_id)
);

INSERT INTO exams(`name`) 
VALUE ('Spring MVC'),
('Neo4j'),
('Oracle 11g');

INSERT INTO students(`name`) 
VALUE ('Mila'),
('Toni'),
('Ron');

INSERT INTO students_exams(student_id, exam_id)
VALUES ('1', '101'),
('1', '102'),
('2','101'),
('3','103'),
('2', '102'),
('2', '103');


# 4.
CREATE TABLE teachers(
	teacher_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    manager_id INT DEFAULT NULL
) AUTO_INCREMENT = 101;

INSERT INTO teachers(`name`, manager_id)
VALUES 
('John', null),
('Maya', 106),
('Silvia', 106),
('Ted', 105),
('Mark', 101),
('Greta', 101);

ALTER TABLE teachers
ADD CONSTRAINT fk_manager
FOREIGN KEY (manager_id)
REFERENCES teachers(teacher_id);


# 5.
CREATE TABLE cities(
	city_id INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL
);


CREATE TABLE customers(
	customer_id INT AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(50) NOT NULL,
    birthday DATE,
    city_id INT,
    CONSTRAINT fk_city FOREIGN KEY (city_id)
    REFERENCES cities(city_id)
);

CREATE TABLE orders(
	order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE item_types(
	item_type_id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50)
);

CREATE TABLE items(
	item_id INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(50),
    item_type_id INT,
    CONSTRAINT fk_type FOREIGN KEY (item_type_id) 
    REFERENCES item_types(item_type_id)
);


CREATE TABLE order_items(
	order_id INT NOT NULL,
    item_id INT NOT NULL,
    CONSTRAINT pk_ordersss PRIMARY KEY (order_id, item_id),
    CONSTRAINT fk_orde FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items FOREIGN KEY (item_id) REFERENCES items(item_id)
);


# 6.
CREATE TABLE majors(
	major_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	`name` VARCHAR(50) NOT NULL
);

CREATE TABLE students(
	student_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    student_number VARCHAR(12) not null,
    student_name VARCHAR(50) NOT NULL,
    major_id INT,
    CONSTRAINT fk_majors FOREIGN KEY (major_id) REFERENCES majors(major_id)
);

CREATE TABLE payments(
	payment_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_date DATE,
    payment_amount DECIMAL(8,2) NOT NULL,
    student_id INT,
    CONSTRAINT fk_stud FOREIGN KEY (student_id) REFERENCES students(student_id)
);

CREATE TABLE subjects(
	subject_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    subject_name VARCHAR(50) not null
);

CREATE TABLE agenda(
	student_id INT NOT NULL,
    subject_id INT NOT NULL,
    CONSTRAINT pk_both PRIMARY KEY (student_id, subject_id),
	CONSTRAINT fk_st FOREIGN KEY (student_id) REFERENCES students(student_id),
	CONSTRAINT fk_sub FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);


# 9.
SELECT m.mountain_range, p.peak_name, p.elevation as 'peak_elevation'
FROM mountains as m JOIN peaks as p ON m.id = p.mountain_id
WHERE m.mountain_range = 'Rila'
ORDER BY `peak_elevation` DESC;
