USE instd;

# 2.
INSERT INTO addresses(address, town, country, user_id)
(SELECT username, `password`, ip, age FROM users WHERE gender = 'M');

# 3.
UPDATE addresses
SET country = (
	CASE 
		WHEN country LIKE 'B%' THEN 'Blocked'
        WHEN country LIKE 'T%' THEN 'Test'
        WHEN country LIKE 'P%' THEN 'In Progress'
        ELSE country
	END
);

# 4.

DELETE FROM addresses
WHERE id % 3 = 0;


# 5.

SELECT username, gender, age
FROM users
ORDER BY age DESC, username asc;


# 6. 
SELECT p.id, p.date as date_and_time, p.description, COUNT(c.id) as commentsCount
FROM comments as c JOIN photos as p ON c.photo_id = p.id
GROUP BY p.id
ORDER BY commentsCount DESC, p.id ASC
LIMIT 5;

# 7.

SELECT CONCAT(u.id, ' ', u.username) as id_username, u.email
FROM users as u LEFT JOIN users_photos as up ON u.id = up.user_id 
JOIN photos as p ON p.id = up.photo_id
WHERE p.id = u.id
ORDER BY u.id ASC;


# 8.
SELECT p.id as photo_id, COUNT(l.id) as likes_count, COUNT(c.id) as comments_count 
FROM comments as c JOIN photos as p ON c.photo_id = p.id 
JOIN likes as l ON l.photo_id = p.id
GROUP BY p.id
ORDER BY likes_count DESC, comments_count DESC, p.id ASC;


# 9.

SELECT CONCAT(SUBSTRING(description,1,30),'...') as summary, `date`
FROM photos
WHERE DAY(date) = 10 
ORDER BY `date` DESC;


# 10.
DELIMITER %
CREATE FUNCTION  udf_users_photos_count(username VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN
	RETURN (
		SELECT COUNT(p.id)
        FROM users as u JOIN users_photos as up ON up.user_id = u.id
        JOIN photos as p ON p.id = up.photo_id
        WHERE u.username = username
    );
END
%

SELECT udf_users_photos_count('ssantryd') AS photosCount;


# 11.
DELIMITER %
CREATE PROCEDURE udp_modify_user(address VARCHAR(30), town VARCHAR(30))
BEGIN
	IF((SELECT COUNT(*) FROM users as u JOIN addresses as a ON a.user_id = u.id WHERE a.address = address AND a.town = town AND a.user_id = u.id) > 0 )
		THEN UPDATE users SET age = age + 10;
	END IF;
END
%

CALL udp_modify_user ('97 Valley Edge Parkway', 'Divinópolis');
SELECT u.username, u.email,u.gender,u.age,u.job_title FROM users AS u
WHERE u.username = 'eblagden21';