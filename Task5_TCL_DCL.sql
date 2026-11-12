USE PlayStoreDB;

START TRANSACTION;

UPDATE Apps
SET Rating = 4.8
WHERE AppID = 1002;

COMMIT;


START TRANSACTION;

UPDATE Apps
SET Price = 199
WHERE AppID = 1006;

ROLLBACK;

START TRANSACTION;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID,
 CategoryID, Rating, Downloads, Price)
VALUES
(2001, 'WhatsApp', 102, 201, 304, 4.5, 1000000000, 0);

COMMIT;



START TRANSACTION;

INSERT INTO Developers
(DeveloperID, DeveloperName, Country, FoundedYear)
VALUES
(999, 'Test Developer', 'India', 2024);

ROLLBACK;


START TRANSACTION;

UPDATE Apps
SET Rating = 4.7
WHERE AppID = 1001;

SAVEPOINT rating_savepoint;

ROLLBACK;



START TRANSACTION;

UPDATE Apps
SET Rating = 4.7
WHERE AppID = 1001;

SAVEPOINT rating_sp;

UPDATE Apps
SET Rating = 4.6
WHERE AppID = 1002;

ROLLBACK TO SAVEPOINT rating_sp;

COMMIT;



START TRANSACTION;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID,
 CategoryID, Rating, Downloads, Price)
VALUES
(2002, 'Test Application', 102, 201, 304, 4.2, 100000, 50);

SAVEPOINT app_savepoint;

UPDATE Apps
SET Price = 100
WHERE AppID = 2002;

ROLLBACK TO SAVEPOINT app_savepoint;

COMMIT;


GRANT SELECT
ON PlayStoreDB.Apps
TO 'student'@'localhost';



GRANT SELECT, INSERT
ON PlayStoreDB.Apps
TO 'student'@'localhost';


REVOKE INSERT
ON PlayStoreDB.Apps
FROM 'student'@'localhost';



START TRANSACTION;

UPDATE Apps
SET Rating = 4.8
WHERE AppID = 1001;

SAVEPOINT update_sp;

UPDATE Apps
SET Price = 150
WHERE AppID = 1003;

UPDATE Apps
SET Rating = 4.9
WHERE AppID = 1005;

ROLLBACK TO SAVEPOINT update_sp;

COMMIT;


START TRANSACTION;

INSERT INTO Categories
(CategoryID, CategoryName, MinimumAge)
VALUES
(306, 'Health', 12);

INSERT INTO Categories
(CategoryID, CategoryName, MinimumAge)
VALUES (307, 'Travel', 3);

SAVEPOINT category_sp;

ROLLBACK TO SAVEPOINT category_sp;

ROLLBACK;


GRANT SELECT, INSERT, UPDATE
ON PlayStoreDB.Apps
TO 'student'@'localhost';


-- 4. Revoke UPDATE privilege

REVOKE UPDATE
ON PlayStoreDB.Apps
FROM 'student'@'localhost';


-- 5. Grant SELECT privilege on Developers
-- and revoke the same privilege

GRANT SELECT
ON PlayStoreDB.Developers
TO 'student'@'localhost';

REVOKE SELECT
ON PlayStoreDB.Developers
FROM 'student'@'localhost';



START TRANSACTION;

UPDATE Apps
SET Rating = 4.6
WHERE AppID = 1003;

UPDATE Apps
SET Price = 99
WHERE AppID = 1005;

INSERT INTO Apps
(AppID, AppName, DeveloperID, PublisherID,
 CategoryID, Rating, Downloads, Price)
VALUES
(2003, 'Sample App', 104, 201, 302, 4.3, 50000, 0);

COMMIT;


SELECT * FROM Apps
WHERE AppID IN (1001, 1002, 1003, 1005, 2001, 2002, 2003);

SELECT * FROM Developers
WHERE DeveloperID = 999;

SELECT * FROM Categories
WHERE CategoryID IN (306, 307);