# 2.
INSERT INTO games(name, rating, budget, team_id)
(SELECT reverse(lower(SUBSTRING(name,2))) as `name`, id, leader_id*100, id FROM teams WHERE id BETWEEN 1 AND 9);

# 3.
UPDATE employees
SET salary = salary + 1000
WHERE age <= 40 AND salary < 5000;

# 4.
DELETE FROM games as g
WHERE release_date IS NULL AND id NOT IN (SELECT game_id FROM games_categories WHERE category_id IS NOT NULL) ;

# 5.
SELECT first_name, last_name, age, salary, happiness_level FROM employees ORDER BY salary, id;

# 6.
SELECT t.name as team_name, a.name as address_name, CHAR_LENGTH(a.name) as count_of_characters
FROM teams as t JOIN offices as o ON t.office_id = o.id JOIN addresses as a ON a.id = o.address_id
WHERE o.website IS NOT NULL
ORDER BY team_name, address_name;


# 7.
SELECT c.name, COUNT(g.id) as games_count, ROUND(AVG(g.budget),2) as abg_budget, MAX(g.rating) as max_rating
FROM categories as c LEFT JOIN games_categories as gc ON gc.category_id = c.id 
JOIN games as g ON g.id = gc.game_id
GROUP BY c.name
HAVING max_rating >= 9.5
ORDER BY games_count DESC, c.name ASC;

# 8.
SELECT g.name, g.release_date, CONCAT(SUBSTRING(g.description, 1, 10), '...') as summary,
	(CASE 
		WHEN MONTH(g.release_date) in ('01','02','03') THEN 'Q1'
        WHEN MONTH(g.release_date) in ('04','05','06') THEN 'Q2'
		WHEN MONTH(g.release_date) in ('07','08','09') THEN 'Q3'
		ELSE 'Q4'
	END) as quarter, t.name
FROM games as g JOIN teams as t on t.id = g.team_id
WHERE YEAR(g.release_date) = 2022 AND MONTH(g.release_date) MOD 2 = 0 AND g.name LIKE '%2'
ORDER BY quarter;


# 9.
SELECT g.name, 
	(CASE
		WHEN g.budget < 50000 THEN 'Normal budget'
        ELSE 'Insufficient budget'
	END) as budget_level, t.name, a.name  
FROM games as g
JOIN teams as t ON t.id = g.team_id JOIN offices as o ON o.id = t.office_id 
JOIN addresses as a ON a.id = o.address_id
WHERE g.release_date IS NULL AND (SELECT COUNT(category_id) FROM games_categories WHERE game_id = g.id) = 0
ORDER BY g.name;


# 10.
DROP FUNCTION udf_game_info_by_name;
DELIMITER %%
CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20)) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
	RETURN (
		SELECT CONCAT('The ', game_name, ' is developed by a ', t.name, ' in an office with an address ', a.name) as info
        FROM games as g JOIN teams as t ON t.id = g.team_id 
        JOIN offices as o ON o.id = t.office_id 
        JOIN addresses as a ON a.id = o.address_id
        WHERE g.name = game_name
    );
END
%%

SELECT udf_game_info_by_name('Bitwolf') AS info;
%% 
%%
%%
# 11.
DROP PROCEDURE udp_update_budget;
%%
DELIMITER %%
CREATE PROCEDURE udp_update_budget(min_game_rating FLOAT)
BEGIN
	UPDATE games
    SET budget = budget + 100000 and adddate(release_date, INTERVAL 1 YEAR)
	WHERE (SELECT COUNT(category_id) FROM games_categories WHERE game_id = id) <= 0 AND rating > min_game_rating AND release_date IS NOT NULL;
END 
%%

CALL udp_update_budget(8);