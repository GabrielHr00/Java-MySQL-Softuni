# 1.
CREATE TABLE mountains(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name varchar(40)
);

CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40),
    mountain_id INT,
    CONSTRAINT fk_mountain_id FOREIGN KEY (mountain_id) REFERENCES mountains(id)
);


# 2.
SELECT
    driver_id,
    vehicle_type,
    CONCAT(c.first_name, ' ', c.last_name) AS 'driver_name'
FROM
    vehicles AS v JOIN
    campers AS c ON v.driver_id = c.id;
    
    
# 3.
SELECT 
    r.starting_point AS 'route_starting_point',
    r.end_point AS 'route_ending_point',
    r.leader_id,
    CONCAT(c.first_name, ' ', c.last_name) AS 'leader_name'
FROM
    campers AS c
        JOIN
    routes AS r ON c.id = r.leader_id;


# 4.
CREATE TABLE mountains(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name varchar(40)
);

CREATE TABLE peaks(
	id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(40),
    mountain_id INT,
    CONSTRAINT fk_mountain_id FOREIGN KEY (mountain_id) REFERENCES mountains(id) ON DELETE CASCADE
);