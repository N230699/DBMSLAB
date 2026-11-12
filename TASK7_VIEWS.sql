USE PlayStoreDB;

-- ==========================================
-- PART A: VERIFY DATABASE
-- ==========================================

SHOW TABLES;

SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;


-- ==========================================
-- LEVEL 1: UNDERSTANDING
-- ==========================================

-- Q1. Create a View displaying all application records

CREATE OR REPLACE VIEW All_Apps AS
SELECT * FROM Apps;

SELECT * FROM All_Apps;


-- Q2. Display AppID, AppName, Rating and Price

CREATE OR REPLACE VIEW Application_Details_View AS
SELECT AppID, AppName, Rating, Price
FROM Apps;

SELECT * FROM Application_Details_View;


-- Q3. Applications having rating >= 4.5

CREATE OR REPLACE VIEW Highly_Rated_Apps AS
SELECT *
FROM Apps
WHERE Rating >= 4.5;

SELECT * FROM Highly_Rated_Apps;


-- Q4. Display only free applications

CREATE OR REPLACE VIEW Free_Apps AS
SELECT *
FROM Apps
WHERE Price = 0;

SELECT * FROM Free_Apps;


-- Q5. Retrieve all records from Highly_Rated_Apps View

SELECT * FROM Highly_Rated_Apps;


-- Q6. Display all Views available in database

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ==========================================
-- LEVEL 2: APPLICATION
-- ==========================================

-- Q1. App names and developer names

CREATE OR REPLACE VIEW App_Developer_View AS
SELECT A.AppName, D.DeveloperName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID;

SELECT * FROM App_Developer_View;


-- Q2. App names and publisher names

CREATE OR REPLACE VIEW App_Publisher_View AS
SELECT A.AppName, P.PublisherName
FROM Apps A
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID;

SELECT * FROM App_Publisher_View;


-- Q3. App names and category names

CREATE OR REPLACE VIEW App_Category_View AS
SELECT A.AppName, C.CategoryName
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

SELECT * FROM App_Category_View;


-- Q4. Application details with developer names and countries

CREATE OR REPLACE VIEW App_Developer_Details AS
SELECT A.AppID, A.AppName, A.Rating, A.Price, A.Downloads,
       D.DeveloperName, D.Country
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID;

SELECT * FROM App_Developer_Details;


-- Q5. Total number of apps for each category

CREATE OR REPLACE VIEW Category_App_Count AS
SELECT CategoryID, COUNT(*) AS Total_Applications
FROM Apps
GROUP BY CategoryID;

SELECT * FROM Category_App_Count;


-- Q6. Total number of apps for each developer

CREATE OR REPLACE VIEW Developer_App_Count AS
SELECT DeveloperID, COUNT(*) AS Total_Applications
FROM Apps
GROUP BY DeveloperID;

SELECT * FROM Developer_App_Count;


-- Q7. Average rating of apps for each category

CREATE OR REPLACE VIEW Category_Average_Rating AS
SELECT CategoryID, AVG(Rating) AS Average_Rating
FROM Apps
GROUP BY CategoryID;

SELECT * FROM Category_Average_Rating;


-- Q8. Apps with rating > 4.3 and developer names

CREATE OR REPLACE VIEW Highly_Rated_Developer_Apps AS
SELECT A.AppName, A.Rating, D.DeveloperName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
WHERE A.Rating > 4.3;

SELECT * FROM Highly_Rated_Developer_Apps;


-- Q9. Retrieve selected columns from an existing View using WHERE

SELECT AppName, DeveloperName
FROM App_Developer_Details
WHERE Country = 'USA';


-- Q10. Display definition of a created View

SHOW CREATE VIEW App_Developer_View;


-- ==========================================
-- LEVEL 3: MEDIUM TO ADVANCED
-- ==========================================

-- Q1. Category names and total app counts using JOIN and GROUP BY

CREATE OR REPLACE VIEW Category_Wise_Count AS
SELECT C.CategoryName,
       COUNT(A.AppID) AS Total_Applications
FROM Categories C
INNER JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

SELECT * FROM Category_Wise_Count;


-- Q2. Developers having more than one app

CREATE OR REPLACE VIEW Developers_Multiple_Apps AS
SELECT D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications
FROM Developers D
INNER JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName
HAVING COUNT(A.AppID) > 1;

SELECT * FROM Developers_Multiple_Apps;


-- Q3. Each category with highest and lowest app ratings

CREATE OR REPLACE VIEW Category_Rating_Range AS
SELECT C.CategoryName,
       MAX(A.Rating) AS Highest_Rating,
       MIN(A.Rating) AS Lowest_Rating
FROM Categories C
INNER JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

SELECT * FROM Category_Rating_Range;


-- Q4. Developer names and total apps developed by each developer

CREATE OR REPLACE VIEW Developer_Total_Apps AS
SELECT D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications
FROM Developers D
LEFT JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName;

SELECT * FROM Developer_Total_Apps;


-- Q5. App, developer, publisher and category details

CREATE OR REPLACE VIEW Complete_App_Details AS
SELECT A.AppID, A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName,
       A.Rating, A.Downloads, A.Price
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

SELECT * FROM Complete_App_Details;


-- Q6. Highly rated apps with developer and category names

CREATE OR REPLACE VIEW Highly_Rated_App_Details AS
SELECT A.AppName, A.Rating,
       D.DeveloperName,
       C.CategoryName
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
WHERE A.Rating >= 4.5;

SELECT * FROM Highly_Rated_App_Details;


-- Q7. Publisher names, total apps and downloads
-- Including publishers without applications

CREATE OR REPLACE VIEW Publisher_App_Summary AS
SELECT P.PublisherName,
       COUNT(A.AppID) AS Total_Applications,
       COALESCE(SUM(A.Downloads), 0) AS Total_Downloads
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
GROUP BY P.PublisherID, P.PublisherName;

SELECT * FROM Publisher_App_Summary;


-- Q8. Retrieve records using filtering and sorting

SELECT *
FROM Complete_App_Details
WHERE Rating > 4.3
ORDER BY Downloads DESC;


-- Q9. Create simple updatable View and update app rating

CREATE OR REPLACE VIEW App_Rating_View AS
SELECT AppID, AppName, Rating
FROM Apps;

UPDATE App_Rating_View
SET Rating = 4.8
WHERE AppID = 1008;

-- Verify changes in View

SELECT * FROM App_Rating_View;

-- Verify changes in Apps table

SELECT * FROM Apps;


-- Q10. Drop one created View and verify

DROP VIEW Free_Apps;

SHOW FULL TABLES
WHERE Table_type = 'VIEW';


-- ==========================================
-- OPTIONAL: REAL-WORLD GOOGLE PLAY STORE ANALYSIS
-- ==========================================

-- Q1. View for all highly rated apps

CREATE OR REPLACE VIEW Real_Highly_Rated_Apps AS
SELECT *
FROM Apps
WHERE Rating >= 4.5;

SELECT * FROM Real_Highly_Rated_Apps;


-- Q2. Category-wise app statistics

CREATE OR REPLACE VIEW Category_Statistics AS
SELECT C.CategoryName,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Categories C
LEFT JOIN Apps A
ON C.CategoryID = A.CategoryID
GROUP BY C.CategoryID, C.CategoryName;

SELECT * FROM Category_Statistics;


-- Q3. Developer-wise app statistics

CREATE OR REPLACE VIEW Developer_Statistics AS
SELECT D.DeveloperName,
       COUNT(A.AppID) AS Total_Applications,
       AVG(A.Rating) AS Average_Rating
FROM Developers D
LEFT JOIN Apps A
ON D.DeveloperID = A.DeveloperID
GROUP BY D.DeveloperID, D.DeveloperName;

SELECT * FROM Developer_Statistics;


-- Q4. Publisher-wise app counts and total downloads

CREATE OR REPLACE VIEW Publisher_Statistics AS
SELECT P.PublisherName,
       COUNT(A.AppID) AS Total_Applications,
       COALESCE(SUM(A.Downloads), 0) AS Total_Downloads
FROM Publishers P
LEFT JOIN Apps A
ON P.PublisherID = A.PublisherID
GROUP BY P.PublisherID, P.PublisherName;

SELECT * FROM Publisher_Statistics;


-- Q5. View combining app, developer, publisher and category information

CREATE OR REPLACE VIEW App_Complete_Information AS
SELECT A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName,
       A.Rating,
       A.Downloads,
       A.Price
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

SELECT * FROM App_Complete_Information;


-- Q6. Apps with rating greater than overall average rating

CREATE OR REPLACE VIEW Above_Average_Rating_Apps AS
SELECT AppID, AppName, Rating
FROM Apps
WHERE Rating > (SELECT AVG(Rating) FROM Apps);

SELECT * FROM Above_Average_Rating_Apps;


-- Q7. Most downloaded apps in each category

CREATE OR REPLACE VIEW Most_Downloaded_Per_Category AS
SELECT A.AppID,
       A.AppName,
       C.CategoryName,
       A.Downloads
FROM Apps A
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID
WHERE A.Downloads = (
    SELECT MAX(A2.Downloads)
    FROM Apps A2
    WHERE A2.CategoryID = A.CategoryID
);

SELECT * FROM Most_Downloaded_Per_Category;


-- Q8. Simple Play Store Dashboard

CREATE OR REPLACE VIEW PlayStore_Dashboard AS
SELECT A.AppName,
       D.DeveloperName,
       P.PublisherName,
       C.CategoryName,
       A.Rating,
       A.Downloads,
       A.Price
FROM Apps A
INNER JOIN Developers D
ON A.DeveloperID = D.DeveloperID
INNER JOIN Publishers P
ON A.PublisherID = P.PublisherID
INNER JOIN Categories C
ON A.CategoryID = C.CategoryID;

SELECT * FROM PlayStore_Dashboard;


-- ==========================================
-- FINAL: DISPLAY ALL AVAILABLE VIEWS
-- ==========================================

SHOW FULL TABLES
WHERE Table_type = 'VIEW';