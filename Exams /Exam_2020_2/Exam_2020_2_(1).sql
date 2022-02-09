-- DROP DATABASE instd;

CREATE DATABASE instd;
USE instd;

CREATE TABLE photos(
	id INT AUTO_INCREMENT PRIMARY KEY,
    description TEXT NOT NULL,
    date DATETIME NOT NULL,
    views INT DEFAULT 0 NOT NULL
);

CREATE TABLE comments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	comment VARCHAR(255) NOT NULL,
    date DATETIME NOT NULL,
    photo_id INT NOT NULL,
    CONSTRAINT fk_photo
    FOREIGN KEY (photo_id)
    REFERENCES photos(id)
);

CREATE TABLE users(
	id INT PRIMARY KEY,
	username VARCHAR(30) NOT NULL UNIQUE,
    password VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL,
    gender CHAR(1) NOT NULL,
    age INT NOT NULL,
    job_title VARCHAR(40) NOT NULL,
    ip VARCHAR(30) NOT NULL
);

CREATE TABLE addresses(
	id INT AUTO_INCREMENT PRIMARY KEY,
	address VARCHAR(30) NOT NULL,
    town VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TABLE likes(
	id INT AUTO_INCREMENT PRIMARY KEY,
	photo_id INT,
    user_id INT,
    CONSTRAINT fk_photo1
    FOREIGN KEY (photo_id)
    REFERENCES photos(id),
    CONSTRAINT fk_user1
    FOREIGN KEY (user_id)
    REFERENCES users(id)
);

CREATE TABLE users_photos(
    user_id INT NOT NULL,
	photo_id INT NOT NULL,
    CONSTRAINT fk_user2
    FOREIGN KEY (user_id)
    REFERENCES users(id),
    CONSTRAINT fk_photo2
    FOREIGN KEY (photo_id)
    REFERENCES photos(id)
);

