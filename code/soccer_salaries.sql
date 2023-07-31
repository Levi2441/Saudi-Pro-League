CREATE TABLE used (
	id INT PRIMARY KEY,
    player_name VARCHAR(40),
    pos VARCHAR(5),
    age INT,
    state VARCHAR(10),
    club_name VARCHAR(40) REFERENCES club(club_name) ON DELETE CASCADE
);

#Queries on Usde to gather information to help build club table
#Return table of all clubs and the number of different clubs
SELECT DISTINCT(used.club_name) 
FROM used;
DESCRIBE used;
DROP TABLE used;

#################################################################################################################

#CRUD Operatins
CREATE TABLE league (
    league_name VARCHAR(40) PRIMARY KEY,
    revenue BIGINT
);

SELECT * FROM league;
INSERT INTO league VALUES("Premier League", 1200000);
UPDATE league SET revenue = 100000 WHERE league_name = "Bundesliga" OR league_name = "Ligue 1";
DELETE FROM league WHERE league.league_name = "Saudi Pro League";
DROP TABLE league;

CREATE TABLE club (
    club_name VARCHAR(40) PRIMARY KEY,
    league_name VARCHAR(40),
    FOREIGN KEY(league_name) REFERENCES league(league_name) ON DELETE CASCADE
);
SELECT COUNT(club_name) FROM club;
INSERT INTO club VALUES("Manchester City", "Premier League");
UPDATE club SET league_name = "Ligue 1" WHERE club_name = "Manchester United";
DELETE FROM club WHERE club_name = "Manchester City";
DROP TABLE club;

CREATE TABLE player (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(40),
    pos VARCHAR(3),
    age INT,
    state VARCHAR(10),
    club_name VARCHAR(40),
    UNIQUE (player_name),
	FOREIGN KEY(club_name) REFERENCES club(club_name) ON DELETE CASCADE
);

ALTER TABLE used RENAME TO player;
SELECT * FROM player LIMIT 3100;
INSERT INTO player VALUES(6111,"Christian Pulisic", "F", 22, "Reserve", "Chelsea");
UPDATE player SET club_name = "AC Milan" WHERE player_id = 6111;
DELETE FROM club WHERE player_id = 6111;
DROP TABLE player;

CREATE TABLE salary (
	player_id INT PRIMARY KEY,
    weekly_salary INT,
    FOREIGN KEY(player_id) REFERENCES player(id) ON DELETE CASCADE
);

SELECT COUNT(player_id) FROM salary;
SELECT * FROM salary LIMIT 3100;
INSERT INTO salary VALUES(6111, 30000);
UPDATE salary SET weekly_salary = 40000 WHERE player_id = 6111;
DELETE FROM salary WHERE player_id = 6111;
DROP TABLE salary;

#################################################################################################################
#Basic Queries 

#return id, name, position of forwards in descendign order
SELECT id, player_name,pos
FROM player
WHERE pos = "F"
ORDER BY player_name DESC;

#return all the information of players with salaries in descending order
SELECT *, salary.weekly_salary
FROM player
JOIN salary 
ON player.id = salary.player_id
ORDER BY weekly_salary DESC;

#return the names of the players with 10 highest salaries
SELECT id, player_name, weekly_salary
FROM player
JOIN salary
ON
player.id = salary.player_id
ORDER BY weekly_salary DESC
LIMIT 10;


#return the names of fowards with 10 highest salaries
SELECT id, player_name, weekly_salary
FROM player
JOIN salary
ON
player.id = salary.player_id
WHERE player.pos = "F"
ORDER BY weekly_salary DESC
LIMIT 10;

#Return the names of defenders with 10 highest salaries
SELECT id, player_name, weekly_salary
FROM player
JOIN salary
ON
player.id = salary.player_id
WHERE player.pos = "D"
ORDER BY weekly_salary DESC
LIMIT 10;

#return the number of clubs in each league
SELECT league_name, COUNT(club_name) 
FROM club
GROUP BY league_name; 

#first find number of people in each league

SELECT club.league_name, Count(player.id)
FROM player 
JOIN club
ON player.club_name = club.club_name
GROUP BY club.league_name;

#find the number of players whose salary is greater than 200,000 and return which league they are from
SELECT club.league_name, COUNT(player.id)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE salary.weekly_salary > 200000
GROUP BY club.league_name;

#find the number of players whose salary is less than 2,000 and return which league they are from
SELECT club.league_name, COUNT(player.id)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE salary.weekly_salary < 2000
GROUP BY club.league_name;

#find the average weekly salaries in each league
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#inquire about ages and salaries
#find the average ages of each league and their average salaries
SELECT club.league_name, AVG(salary.weekly_salary), AVG(player.age)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are 22 and younger
SELECT club.league_name, AVG(salary.weekly_salary), AVG(player.age)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.age <= 22
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are 32 and older
SELECT club.league_name, AVG(salary.weekly_salary), AVG(player.age)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.age >= 32
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are "in their prime"
SELECT club.league_name, AVG(salary.weekly_salary), AVG(player.age)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.age <= 32 AND player.age >= 22
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;


#find the average salaries from each league of players who are defenders
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.pos = 'D'
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are midfielders
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.pos = 'M'
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are fowards
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.pos = 'F'
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#inquire about starters/reserves 
#find the average salaries from each league of players who are starters
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.state = 'Starter'
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are reserves
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.state = 'Reserve'
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are young and reserves
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.state = 'Reserve' AND player.age <= 22
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the average salaries from each league of players who are young and starters
SELECT club.league_name, AVG(salary.weekly_salary)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE player.state = 'Starter' AND player.age <= 22
GROUP BY club.league_name
ORDER BY AVG(weekly_salary) DESC;

#find the number of people that are below the average for each league
SELECT club.league_name, COUNT(player.id)
FROM player 
JOIN club
ON player.club_name = club.club_name
JOIN salary
ON player.id = salary.player_id
WHERE salary.weekly_salary < 2000
GROUP BY club.league_name;

#inquire about the distribution
#################################################################################################################
#Nested Queries

#Find the names of the people in the  that make more than 300000 weekly
SELECT club_name, id, player_name
FROM player 
WHERE player.id IN (
	SELECT player_id
	FROM salary
	WHERE weekly_salary > 300000
);

#Find the top 10 earners in the saudi league
SELECT player_name, weekly_salary
FROM salary
JOIN player
ON player.id = salary.player_id
WHERE salary.player_id IN (
	SELECT id
	FROM player
	WHERE player.club_name IN (
		SELECT club_name
		FROM club
		WHERE league_name = "Saudi Pro League"
	)
)
ORDER BY weekly_salary DESC
LIMIT 10;

#return the average salaries of each league in a table 

SELECT AVG(weekly_salary)
FROM salary
WHERE player_id IN (
	SELECT id
	FROM player 
	WHERE club_name IN (
		SELECT club_name 
		FROM club
		WHERE league_name = "Premier League"
	)
);

SELECT AVG(weekly_salary)
FROM salary
WHERE player_id IN (
	SELECT id
	FROM player 
	WHERE club_name IN (
		SELECT club_name 
		FROM club
		WHERE league_name = "Saudi Pro League"
	)
);

SELECT AVG(weekly_salary)
FROM salary
WHERE player_id IN (
	SELECT id
	FROM player 
	WHERE club_name IN (
		SELECT club_name 
		FROM club
		WHERE league_name = "Ligue 1"
	)
);

#avg salaries of all leagues
SELECT AVG(weekly_salary)
FROM salary
WHERE player_id IN (
	SELECT id
	FROM player 
	WHERE club_name IN (
		SELECT club_name 
		FROM club
		WHERE league_name IN (
			SELECT league_name
            FROM league
        )
	)
);

#################################################################################################################

#Procedures
#return the average salaries of each league in a table 

USE `firstP`;
DROP procedure IF EXISTS `AverageLeagueSalary`;

DELIMITER $$
USE `firstP`$$
CREATE PROCEDURE `AverageLeagueSalary`(IN league VARCHAR(30))
BEGIN
	SELECT AVG(weekly_salary)
	FROM salary
	WHERE player_id IN (
		SELECT id
		FROM player 
		WHERE club_name IN (
			SELECT club_name 
			FROM club
			WHERE league_name = league
		)
	);
END$$
DELIMITER ;

