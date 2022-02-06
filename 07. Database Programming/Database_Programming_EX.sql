# 1.

DELIMITER %%
CREATE PROCEDURE usp_get_employees_salary_above_35000() 
BEGIN
	SELECT first_name, last_name 
    FROM employees 
    WHERE salary > 35000
    ORDER BY first_name, last_name, employee_id;
END %%


CALL usp_get_employees_salary_above_35000();

DROP PROCEDURE usp_get_employees_salary_above_35000();


# 2.

DELIMITER %%
CREATE PROCEDURE usp_get_employees_salary_above(number DECIMAL(20,4))
BEGIN
	SELECT first_name, last_name FROM employees WHERE salary >= number
    ORDER BY first_name, last_name, employee_id;
END %%

CALL usp_get_employees_salary_above('45000');


# 3.

DELIMITER %%
CREATE PROCEDURE usp_get_towns_starting_with(namy VARCHAR(50)) 
BEGIN
	SELECT `name` as town_name FROM towns as t
    WHERE `name` LIKE CONCAT(namy, '%')
    ORDER BY town_name;
END %%


CALL usp_get_towns_starting_with('B');


# 4.

DELIMITER %%
CREATE PROCEDURE usp_get_employees_from_town(town_n VARCHAR(50))
BEGIN
	SELECT e.first_name, e.last_name
    FROM employees as e JOIN addresses as a USING (address_id) JOIN towns as t ON t.town_id = a.town_id
    WHERE t.name = town_n
    ORDER BY e.first_name, e.last_name, e.employee_id;
END %%


CALL usp_get_employees_from_town('Sofia');


# 5.

DELIMITER %%
CREATE FUNCTION ufn_get_salary_level(sal DECIMAL(19,4)) 
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
	RETURN (
		SELECT 
			CASE 
				WHEN sal < 30000 THEN 'Low'
                WHEN sal BETWEEN 30000 AND 50000 THEN 'Average'
                ELSE 'High'
            END as 'salary_level');
END %%


SELECT salary, ufn_get_salary_level(salary) FROM employees;



# 6.
DELIMITER %%
CREATE PROCEDURE usp_get_employees_by_salary_level(level VARCHAR(7))
BEGIN
	SELECT e.first_name, e.last_name FROM employees as e
    WHERE 
    (e.salary < 30000 AND level = 'low') OR 
    (e.salary BETWEEN 30000 AND 50000 AND level = 'average')
    OR (e.salary > 50000 AND level = 'high')
	ORDER BY e.first_name DESC, e.last_name DESC;
END %% 


CALL usp_get_employees_by_salary_level('High');


DROP PROCEDURE usp_get_employees_by_salary_level;


%%

%%
# 7.
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS BIT
DETERMINISTIC
	RETURN word REGEXP(concat('^[', set_of_letters,']+$')); 

%%
SELECT ufn_is_word_comprised('oistmiahf', 'Sofia');
	-- DROP FUNCTION ufn_is_word_comprised;
%%


# 8.

DELIMITER %%
CREATE PROCEDURE usp_get_holders_full_name()
BEGIN
	SELECT CONCAT(first_name, ' ', last_name) as 'full_name' 
    FROM account_holders
    ORDER BY full_name, id;
END %%

%%

# 9.
DELIMITER %%
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(money DOUBLE(19,4))
BEGIN
	SELECT ah.first_name, ah.last_name 
    FROM account_holders as ah JOIN accounts as a ON a.account_holder_id = ah.id
    GROUP BY ah.id
    HAVING SUM(balance) > money
    ORDER BY ah.id; 
END %%

CALL usp_get_holders_with_balance_higher_than(7000);


%% 
DROP PROCEDURE usp_get_holders_with_balance_higher_than;

# 10.
%% 
CREATE FUNCTION ufn_calculate_future_value(I DECIMAL(19,4), R DOUBLE, T INT)
RETURNS DECIMAL(19,4)
DETERMINISTIC
BEGIN
	RETURN I * (pow((1+R), T));
END %%


# 11.
%%
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, year DECIMAL(19,4))
BEGIN
	SELECT a.id as 'account_id', ah.first_name, ah.last_name, a.balance as 'current_balance', 
    ufn_calculate_future_value(a.balance, years, 5) as 'balance_in_5_years' 
    FROM account_holders as ah JOIN accounts as a ON ah.id = a.account_holder_id
    WHERE a.id = id;
END %% 


# 12.
%%
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	IF money_amount > 0 THEN 
		UPDATE accounts SET balance = balance + money_amount WHERE id = account_id;
		-- SELECT id as 'account_id', account_holder_id, balance FROM accounts WHERE id = account_id;
	END IF;
END;

%%
CALL usp_deposit_money(1, 10);
%%


# 13.
%%
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19,4))
BEGIN
	IF money_amount > 0 AND ((SELECT balance FROM accounts WHERE id = account_id) >= money_amount) THEN 
		UPDATE accounts SET balance = balance - money_amount WHERE id = account_id;
	END IF;
END;
%%

# 14.
%%
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19,4))
BEGIN
	IF(
		(SELECT id FROM accounts WHERE id = from_account_id) = from_account_id AND 
		(SELECT id FROM accounts WHERE id = to_account_id) = to_account_id AND
		amount > 0 AND 
		from_account_id <> to_account_id AND 
		(SELECT balance FROM accounts WHERE id = from_account_id) >= amount
    ) THEN 
		UPDATE accounts SET balance = balance - amount WHERE id = from_account_id;
		UPDATE accounts SET balance = balance + amount WHERE id = to_account_id;
	END IF;
END
%%

%% 
-- DROP PROCEDURE usp_transfer_money;
CALL usp_transfer_money(1,2,10);

%%
%%
SELECT * FROM accounts WHERE id = 1 or id = 2;
%%

# 15.
CREATE TABLE logs(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    old_sum DECIMAL(19,4) NOT NULL,
    new_sum DECIMAL(19,4) NOT NULL
);

%%
CREATE TRIGGER tr_logs AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
	IF OLD.balance <> NEW.balance THEN 
		INSERT INTO logs(account_id, old_sum, new_sum)
		VALUES(
			OLD.id, OLD.balance, NEW.balance
		);
	END IF;
END



# 16.

%% 
CREATE TABLE notification_emails(
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    recipient INT NOT NULL,
    `subject` VARCHAR(100) NOT NULL,
    body VARCHAR(255) NOT NULL
);

%%
CREATE TRIGGER insert_new_mail AFTER INSERT 
ON `logs`
FOR EACH ROW 
BEGIN
	INSERT INTO notification_emails(recipient, `subject`, body)
	VALUES(
		NEW.account_id, 
        CONCAT('Balance change for account: ', NEW.account_id),
        CONCAT('On ', DATE_FORMAT(NOW(), '%b %d %Y at %r'), ' your balance was changed from ', OLD.old_sum, ' to ', NEW.new_sum, '.')
	);
END
%%