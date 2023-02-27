create database alumni;
use alumni;
select count(*) from college_a_hs;
-- Run SQL command to see the structure of six tables
DESC college_a_hs;
DESC college_a_se;
DESC college_a_sj;
DESC college_b_hs;
DESC college_b_se;
DESC college_b_sj;
-- Perform data cleaning on table College_A_HS and store cleaned data in view
CREATE VIEW College_A_HS_V AS (SELECT * FROM college_a_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND
EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM College_A_HS_V;

-- Perform data cleaning on table College_A_SE and store cleaned data in view College_A_SE_V, Remove null values.
CREATE VIEW College_A_SE_V AS (SELECT * FROM college_a_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization
IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM College_A_SE_V;

-- Perform data cleaning on table College_A_SJ and store cleaned data in view College_A_SJ_V, Remove null values.

CREATE VIEW College_A_SJ_V AS (SELECT * FROM college_a_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization
IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_A_SJ_V;

-- Perform data cleaning on table College_B_HS and store cleaned data in view College_B_HS_V, Remove null values.
CREATE VIEW College_B_HS_V AS (SELECT * FROM college_b_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND
EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM College_B_HS_V;

-- Perform data cleaning on table College_B_SE and store cleaned data in view College_B_SE_V, Remove null values.
CREATE VIEW college_b_se_v AS (SELECT * FROM college_b_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization
IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM College_b_se_v;

-- Perform data cleaning on table College_B_SJ and store cleaned data in view College_B_SJ_V, Remove null values.
CREATE VIEW college_b_sj_v AS (SELECT * FROM college_b_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND Organization
IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM college_b_sj_v;

-- Make procedure to use string function/s for converting record of Name, FatherName, MotherName into lower case for views (College_A_HS_V, College_A_SE_V, College_A_SJ_V, College_B_HS_V, College_B_SE_V, College_B_SJ_V) 
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_a_hs_v;
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_a_se_v;
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_a_sj_v;
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_b_hs_v;
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_b_se_v;
SELECT lower(Name),lower(FatherName),lower(MotherName) FROM college_b_sj_v;

-- Write a query to create procedure get_name_collegeA using the cursor to fetch names of all students from college A.
DELIMITER $$
CREATE PROCEDURE get_name_collegeA  (  
INOUT name1 TEXT(40000) ) 
BEGIN   
DECLARE na INT DEFAULT 0; 
DECLARE namelist VARCHAR(16000) DEFAULT "";   
DECLARE namedetail   CURSOR FOR  SELECT Name FROM college_a_hs   
UNION   SELECT Name FROM college_a_se   
UNION   SELECT Name FROM college_a_sj;    
DECLARE CONTINUE HANDLER   FOR NOT FOUND SET na =1;   
OPEN namedetail;   
 getame :  
 LOOP  FETCH FROM namedetail INTO namelist;  
 IF na = 1 THEN  LEAVE getame;  END IF;  
 SET name1 = CONCAT(namelist,";",name1);    
 END LOOP getame;  
 CLOSE namedetail; 
 END$$
 
SET @name1="";
CALL get_name_collegeA(@name1);
SELECT @name1 Name;

-- Write a query to create procedure get_name_collegeB using the cursor to fetch names of all students from college B.
DELIMITER $$
CREATE PROCEDURE get_name_collegeB ( 
INOUT Fname TEXT(40000) )
 BEGIN  
 DECLARE finished INT DEFAULT 0; 
 DECLARE Fnamelist VARCHAR (16000) DEFAULT "";   
 DECLARE Fnamedetails  CURSOR FOR  SELECT name FROM college_b_hs  
 UNION ALL  SELECT name FROM college_b_se  UNION ALL  SELECT name FROM college_b_sj;    
 DECLARE CONTINUE HANDLER  FOR NOT FOUND SET finished=1;    
 OPEN Fnamedetails;  
 getname2:  LOOP  
 FETCH Fnamedetails INTO Fnamelist;  
 IF finished =1 THEN   LEAVE getname2;  
 END IF;    
 SET Fname = CONCAT  (Fnamelist,";",Fname);    
 END LOOP getname2;    
 CLOSE Fnamedetails;   
 END $$
 
 
SET @name2="";
CALL get_name_collegeB(@name2);
SELECT @name2 Name;


-- Calculate the percentage of career choice of College A and College B Alumni
-- (w.r.t Higher Studies, Self Employed and Service/Job)

SELECT 'Higher Studies' ,
(SELECT count(*) FROM college_a_hs)/
((SELECT count(*) FROM college_a_hs)+(SELECT count(*) FROM college_a_se)+(SELECT count(*) FROM college_a_sj)) * 100
College_A_Percentage,
(SELECT count(*) FROM college_b_hs)/
((SELECT count(*) FROM college_b_hs)+(SELECT count(*) FROM college_b_se)+(SELECT count(*) FROM college_b_sj)) * 100
College_B_Percentage
UNION
SELECT 'Self Employed' ,
(SELECT count(*) FROM college_a_se)/
((SELECT count(*) FROM college_a_se)+(SELECT count(*) FROM college_a_hs)+(SELECT count(*) FROM college_a_sj)) * 100
College_A_Percentage ,
(SELECT count(*) FROM college_b_se)/
((SELECT count(*) FROM college_b_hs)+(SELECT count(*) FROM college_b_se)+(SELECT count(*) FROM college_b_sj)) * 100
College_B_Percentage
UNION
SELECT 'Service Job' ,
(SELECT count(*) FROM college_a_sj)/
((SELECT count(*) FROM college_a_hs)+(SELECT count(*) FROM college_a_se)+(SELECT count(*) FROM college_a_sj)) * 100
College_A_Percentage ,
(SELECT count(*) FROM college_b_sj)/
((SELECT count(*) FROM college_b_hs)+(SELECT count(*) FROM college_b_se)+(SELECT count(*) FROM college_b_sj)) * 100
College_B_Percentage ;

 