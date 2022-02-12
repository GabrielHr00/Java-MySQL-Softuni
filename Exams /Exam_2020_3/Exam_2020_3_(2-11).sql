USE fsd;

# 2.
INSERT INTO coaches(first_name, last_name, salary, coach_level)
(SELECT first_name, last_name, salary+salary, CHAR_LENGTH(first_name) FROM players WHERE age >= 45);

# 3.
UPDATE coaches as c
SET c.coach_level = c.coach_level + 1
WHERE (SELECT COUNT(pc.player_id) FROM players_coaches as pc JOIN players as p ON p.id = pc.player_id WHERE c.id = pc.coach_id GROUP BY pc.coach_id) > 0 AND c.first_name LIKE 'A%';


# 4.
DELETE FROM players as p
WHERE p.first_name IN (SELECT first_name FROM coaches) AND p.last_name IN (SELECT last_name FROM coaches) and age >= 45;

-- WHERE (SELECT COUNT(*) FROM coaches as c WHERE c.first_name = p.first_name AND c.last_name = p.last_name AND c.salary = p.salary+p.salary AND age >= 45) = 1;

SELECT COUNT(*) FROM players;


# 5.
SELECT first_name, age, salary
FROM players
order by salary DESC;

# 6.
SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) as full_name, p.age, p.position, p.hire_date
FROM players AS p join skills_data as sk ON p.skills_data_id = sk.id
WHERE p.age < 23 AND p.position = 'A' AND p.hire_date IS NULL AND sk.strength > 50
ORDER BY p.salary asc, p.age asc;


# 7.
SELECT t.name as team_name, t.established, t.fan_base, COUNT(p.id) AS players_count  
FROM teams as t LEFT JOIN players as p ON p.team_id = t.id
GROUP BY t.id
ORDER BY players_count DESC, t.fan_base DESC;

# 8
SELECT MAX(sk.speed) AS max_speed, tow.name as town_name
FROM skills_data as sk RIGHT JOIN players as p ON p.skills_data_id = sk.id
RIGHT JOIN teams as t ON t.id = p.team_id RIGHT JOIN stadiums as st ON t.stadium_id = st.id
RIGHT JOIN towns as tow ON tow.id = st.town_id
WHERE t.name != 'Devify'
GROUP BY town_name
ORDER BY max_speed DESC, town_name;


# 9.

SELECT co.name, COUNT(p.id) as total_count_of_players, SUM(p.salary) as total_sum_of_salaries
FROM players as p
JOIN teams as t ON t.id = p.team_id JOIN stadiums as st ON t.stadium_id = st.id
JOIN towns as tow ON tow.id = st.town_id RIGHT JOIN countries as co ON co.id = tow.country_id
GROUP BY co.name
order by total_count_of_players DESC, co.name;


# 10.
DELIMITER %%
CREATE FUNCTION udf_stadium_players_count(stadium_name VARCHAR(30)) 
	RETURNS INT
    DETERMINISTIC
    BEGIN
		RETURN (
			SELECT COUNT(p.id)
            FROM players as p JOIN teams as t on t.id = p.team_id JOIN stadiums as s ON s.id = t.stadium_id
            WHERE s.name = stadium_name
        );
    END
%%

SELECT udf_stadium_players_count ('Jaxworks') as `count`; 


# 11.
DELIMITER %
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT, team_name VARCHAR(45))
BEGIN
	SELECT CONCAT(p.first_name, ' ', p.last_name) as full_name, p.age, p.salary, sk.dribbling, sk.speed, t.name 
    FROM skills_data as sk JOIN players as p ON sk.id = p.skills_data_id join teams as t
    ON t.id = p.team_id
    WHERE sk.dribbling > min_dribble_points AND t.name = team_name AND sk.speed > (SELECT AVG(speed) FROM skills_data) 
    ORDER BY sk.speed DESC LIMIT 1;
END 
%

CALL udp_find_playmaker(20, 'Skyble');

