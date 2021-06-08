---Create Table 

CREATE TABLE `analysis`.`churn` (
  `CustomerID` INT NOT NULL,
  `Tenure_Months` INT NULL,
  `Multiple_Lines` VARCHAR(45) NULL,
  `Contract` VARCHAR(45) NULL,
  `Monthly_Charges` FLOAT NULL,
  `Total_Charges` VARCHAR(45) NULL,
  `Churn_Label` VARCHAR(45) NULL,
  `Churn_Score` INT NULL,
  `CLTV` INT NULL,
  `Churn_Reason` VARCHAR(255) NULL,
  PRIMARY KEY (`CustomerID`));

--Load data 

LOAD DATA LOCAL INFILE '/Users/sandeepdiddi/OneDrive/Mtech-REVA/reva_mtech/ER_Class_Assignment/churn_data.csv' 
INTO TABLE analysis.churn  FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;


--Create Customer Table 

CREATE TABLE `analysis`.`customer` (
  `CustomerID` INT NOT NULL,
  `City` VARCHAR(45) NULL,
  `Zip_Code` INT NULL,
  `Gender` VARCHAR(45) NULL,
  `Senior_Citizen` VARCHAR(45) NULL,
  `Partner` VARCHAR(45) NULL,
  `Dependents` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerID`));

-- Load Data 

LOAD DATA LOCAL INFILE '/Users/sandeepdiddi/OneDrive/Mtech-REVA/reva_mtech/ER_Class_Assignment/customer_details.csv' 
INTO TABLE analysis.customer  FIELDS TERMINATED BY ','  ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

--1.	Total number of customers who might churn

select Churn_Label,count(*) from 
churn_dev.churn
group by Churn_Label


--'No','1699'
--'Yes','1518'

--2.	City with the most number of customers who are not going to churn

SELECT
    COUNT(cust.CustomerID), 
    City
FROM churn_dev.customer cust
JOIN 
churn cc 
on cc.CustomerID = cust.CustomerID
where cc.Churn_Label = 'No'
GROUP BY City
ORDER BY COUNT(cust.CustomerID) DESC 

--'77','Los Angeles'
--'31','San Diego'
--'30','San Jose'
--'22','San Francisco'
--'19','Sacramento'
--'18','Long Beach'
--'16','Oakland'
--'15','Glendale'
--'14','Fresno'
--'13','Stockton'


--3.	Ratio of Male churnable customers to Female churnable customers 

SELECT sum(case when `Gender` = 'MALE' then 1 else 0 end)/count(*)  as male_ratio,
       sum(case when `Gender` = 'FEMAL' then 1 else 0 end)/count(*) as female_ratio
FROM churn_dev.customer cust
JOIN 
churn_dev.churn cc
on cc.CustomerID = cust.CustomerID
where cc.Churn_Label = 'Yes'

--M'0.4848',F '0.5152'



--4.	Details of the most probable and the most valuable customer who might get churned and who has a known valid churn reason 
select Churn_Score,Churn_Reason,CustomerID,Total_Charges,Churn_Label
from churn 
where Churn_Score = (select max(Churn_Score) from churn where Churn_Label = 'No')
AND 
Churn_Label ='Yes'
order by Total_Charges, LENGTH(Churn_Reason) DESC


--5.	Does the customer with the minimum Total Charge churn?

select Churn_Label,CustomerID from churn
where Total_Charges=(select min(Total_Charges) from churn)

--'No','6180'


--6.	Does the customer with the maximum Total Charge churn?

select Churn_Label,CustomerID from churn
where Total_Charges=(select max(Total_Charges) from churn)

--'No','9093'

--7.	Total number of customer in San Diego who has churn score greater than 15 but less than 50

select count(ch.CustomerID)
from churn ch
JOIN customer cust 
on ch.CustomerID = cust.CustomerID
where City = 'San Diego' 
AND 
Churn_Score BETWEEN 15 AND 50

--17



--8.	City with the most number of senior citizens who might churn
select city, count(cust.CustomerID) as Cust from 
customer cust
JOIN churn cc
on cust.CustomerID = cc.CustomerID
where Churn_Label = 'Yes' AND Senior_Citizen ='Yes'
group by city 
order by Cust DESC


--'Los Angeles','14'
--'San Diego','9'
--'San Francisco','8'
--'San Jose','6'
--'Sacramento','4'
--'Indian Wells','3'
--'Escondido','3'
--'Stockton','3'
--'Berkeley','3'
--'Palmdale','3'

--9.	Count of churnable females who have dependents 





