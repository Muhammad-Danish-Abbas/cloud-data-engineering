CREATE DATABASE BikeStores;
Select * from sales.customers;

select * from production.brands;
select * from sales.orders;
-- Limiting ROWS
select TOP 10
	*
	from 
	production.products
	ORDER BY list_price DESC;
select Top 5
	product_id,product_name,list_price
	
	from production.products
	ORDER BY product_id DESC;
-- Limite Percent 1% 3.21
select TOP 1 Percent
* 
from production.products
order by list_price;


select TOP 2 percent
* 
from production.products
order by model_year;

-- OFFSET AND FETCH work always order by

-- offset skip the starting Rows
-- fetch skip kar kay baki next rows lay kar aye ga
select 
*
from production.products
order by list_price DESC
OFFSET 2 ROWS;

SELECT 
* 
FROM production.products
ORDER BY list_price DESC
OFFSET 1 ROWS
FETCH NEXT 10 ROWS ONLY;
----
SELECT * FROM sales.customers



-- DISTING ---> RETURN UNIQUE VALUE
-- SYNTAX
-- SELECT DISTING COLUMN_NAME 
 -- FROM TABLE NAME
 SELECT CITY 
 FROM sales.customers
 ORDER BY CITY;

  SELECT DISTINCT CITY 
 FROM sales.customers
 ORDER BY CITY;

 SELECT DISTINCT MODEL_YEAR
 FROM production.products;

 SELECT DISTINCT CITY
 FROM SALES.customers;
 SELECT DISTINCT CITY,STATE -- DONO KA COMBINATION UNIQUE DAKYE GA
 FROM SALES.customers;
 

 SELECT PHONE 
 FROM sales.customers;
 SELECT DISTINCT PHONE 
 FROM sales.customers
 ORDER BY PHONE;

 --- LOGICAL OPERATORS
 -- > BOTH CONDITION MUST TRUE AND |---> ATLEAST ONE CONDITION IS TRUE OR
 SELECT *  FROM PRODUCTION.PRODUCTS
 WHERE 
 CATEGORY_ID=1 AND LIST_PRICE > 400
 ORDER BY LIST_PRICE DESC;
 
  SELECT *  FROM PRODUCTION.PRODUCTS
 WHERE 
 CATEGORY_ID=1 OR LIST_PRICE > 400
 ORDER BY LIST_PRICE DESC;

 SELECT * FROM production.PRODUCTS
 WHERE 
 list_price>300 AND model_year= 2018;
 -- CW LIST PRICE > 1000 | BRAND ID 1,2
 SELECT * FROM production.products
 WHERE
 (brand_id = 1 OR brand_id = 2) AND  (LIST_PRICE > 1000);
 
