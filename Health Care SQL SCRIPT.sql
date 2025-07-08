CREATE DATABASE HC;
USE HC;
SELECT * FROM health2;

----- Creating a new table from the above table, in order to start the work------
CREATE TABLE Healthcopy
LIKE health2;


---- INSERTING THE SAME VALUES FROM THE 1 TABLE in the copied TABLE -----
INSERT INTO  Healthcopy
SELECT * FROM health2;
SELECT * FROM Healthcopy;

-------- USIng  ROW_NUMBER() AND WINDOW FUNCTION To find the duplicates-----

SELECT*,
ROW_NUMBER() OVER(PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital,`Insurance Provider`, `Billing Amount`, `Room Number`,
`Admission Type`,`Discharge Date`, Medication, `Test Results`) AS row_num
FROM Healthcopy;

---- Duplicates have been identified by the column row_num by the number which is greater than 1, this means a value is being repeated twice or more and need to be removed-----
------ Making a CTE inorder to see the duplicates and than deleting them------

WITH CTEHEALTH AS (
SELECT*,
ROW_NUMBER() OVER(PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital,`Insurance Provider`, `Billing Amount`, `Room Number`,
`Admission Type`,`Discharge Date`, Medication, `Test Results`) AS row_num
FROM Healthcopy
)
SELECT * FROM CTEHEALTH
WHERE row_num>1;

---- Duplicated values have been clearly identified and we will remove them by using the Delete method but before that we need to make a new table as delete function is a update function------
---- Using the Create statement method from the previous table that will help us create a new table and than we delete those duplicates------

CREATE TABLE `healthcopy2` (
  `Name` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Blood Type` text,
  `Medical Condition` text,
  `Date of Admission` text,
  `Doctor` text,
  `Hospital` text,
  `Insurance Provider` text,
  `Billing Amount` double DEFAULT NULL,
  `Room Number` int DEFAULT NULL,
  `Admission Type` text,
  `Discharge Date` text,
  `Medication` text,
  `Test Results` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
---- Table created with column row_num and now we will put the CTE DATA in it and delete those duplicates------
 SELECT * FROM healthcopy2;
 
 INSERT INTO Healthcopy2
 SELECT*,
ROW_NUMBER() OVER(PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital,`Insurance Provider`, `Billing Amount`, `Room Number`,
`Admission Type`,`Discharge Date`, Medication, `Test Results`) AS row_num
FROM Healthcopy;
SELECT * FROM Healthcopy2;
----- Since the table have been made with a column row-num now we will be able to delete those duplciates-----

DELETE FROM
Healthcopy2
WHERE row_num>1;
SELECT * FROM Healthcopy2
WHERE row_num >1;
----- Duplicates deleted----

SELECT DISTINCT UPPER(Name)
FROM Healthcopy2;
UPDATE Healthcopy2
SET Name= UPPER(Name);
SELECT * FROM Healthcopy2;

ALTER TABLE Healthcopy2
DROP Column row_num;
SELECT * FROM Healthcopy2;
