create database Sport_Products_analysis;
 use Sport_Products_analysis;
 select * from sports;

 SET sql_mode = (SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
UPDATE sports
SET invoice_date = DATE_FORMAT(STR_TO_DATE(invoice_date, '%m/%d/%Y'), '%Y-%m');

    
 /*Top 5 Selling Products by Total Sales:*/
 SELECT Product, SUM(Total_Sales) AS TotalSales
FROM sports
GROUP BY Product
ORDER BY TotalSales DESC
LIMIT 5;

/*Percentage of Total Sales by Region:*/
SELECT Region,
       SUM(Total_Sales) AS TotalSales,
       (SUM(Total_Sales) / (SELECT SUM(Total_Sales) FROM sports)) * 100 AS SalesPercentage
FROM sports
GROUP BY Region
ORDER BY SalesPercentage DESC;


/*Percentage of Operating Profit by Sales Method:*/
SELECT Sales_Method, 
       SUM(Operating_Profit) AS TotalOperatingProfit,
       (SUM(Operating_Profit) / (SELECT SUM(Operating_Profit) FROM sports)) * 100 AS ProfitPercentage
FROM sports
GROUP BY Sales_Method
ORDER BY ProfitPercentage desc;

/*Average Operating Margin by Product Category:*/
SELECT Product,
       AVG(Operating_Margin)*100
	AS AvgOperatingMargin
FROM sports
GROUP BY Product;

/*Total Units Sold by Sales Method:*/
SELECT Sales_Method,
       SUM(Units_Sold) AS TotalUnitsSold
FROM sports
GROUP BY Sales_Method
ORDER BY totalunitssold desc;

/*Which product category generates the highest total sales and operating profit?*/
SELECT Product,
       SUM(Total_Sales) AS TotalSales,
       SUM(Operating_Profit) AS TotalOperatingProfit
FROM sports
GROUP BY Product
ORDER BY TotalOperatingProfit, totalsales DESC
LIMIT 1;

/*KPIS*/

/*total sales*/
SELECT Round(SUM(Total_Sales)) AS TotalSales
FROM sports;

/*Operating Profit Margin:*/
SELECT (SUM(Operating_Profit) / SUM(Total_Sales)) * 100 AS OperatingProfitMargin
FROM sports;

SELECT COUNT(DISTINCT Retailer) AS Total_Retailers
FROM SPORTS;


    
    -- Total sales by month and sales of the same month of the previous year, along with percentage growth
SELECT 
    SUBSTRING(invoice_date, 1, 4) AS sales_year,
    SUBSTRING(invoice_date, 6, 2) AS sales_month,
    SUM(total_sales) AS total_sales,
    LAG(SUM(total_sales)) OVER (PARTITION BY SUBSTRING(invoice_date, 1, 4) ORDER BY SUBSTRING(invoice_date, 6, 2)) AS sales_previous_month,
    ((SUM(total_sales) - LAG(SUM(total_sales)) OVER (PARTITION BY SUBSTRING(invoice_date, 1, 4) ORDER BY SUBSTRING(invoice_date, 6, 2))) / LAG(SUM(total_sales)) OVER (PARTITION BY SUBSTRING(invoice_date, 1, 4) ORDER BY SUBSTRING(invoice_date, 6, 2))) * 100 AS percentage_growth
FROM 
    sports
GROUP BY 
    sales_year, sales_month
ORDER BY 
    sales_year, sales_month;
