--1.	Total number of customers who might churn

select Churn_Label,count(*) from 
churn_dev.churn
group by Churn_Label



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


--3.	Ratio of Male churnable customers to Female churnable customers 

SELECT sum(case when `Gender` = 'MALE' then 1 else 0 end)/count(*)  as male_ratio,
       sum(case when `Gender` = 'FEMAL' then 1 else 0 end)/count(*) as female_ratio
FROM churn_dev.customer cust
JOIN 
churn_dev.churn cc
on cc.CustomerID = cust.CustomerID
where cc.Churn_Label = 'Yes'





