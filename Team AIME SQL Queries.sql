-- Joined the order_item with the order table.
-- The years are then extracted from the order_date column and are selected.
-- The total profit was then calculated using the sum function on the profit column.
-- It's then grouped by the created year column.
-- Ordered by year.
-- This all calculates the total profit by year.

SELECT
	EXTRACT(YEAR FROM o.order_date) AS "year",
	SUM(oi.profit) AS total_profit
FROM	
	offuture.order_item oi
LEFT JOIN
	offuture."order" o ON oi.order_id = o.order_id
GROUP BY
	EXTRACT(YEAR FROM o.order_date)
ORDER BY
	"year";

-- The order_item table was joined with the order table by the order_id.
-- The total profit was then calculated by using the SUM function on the profit column.
-- Doing this calculates the total profit for all the years combined

SELECT
	SUM(oi.profit) AS total_profit
FROM	
	offuture.order_item oi
LEFT JOIN
	offuture."order" o ON oi.order_id = o.order_id;

-- The order_item table was joined with the order table by the order_id.
-- The total sales was then calculated by using the SUM function on the sales column.
-- Doing this calculates the total sales for all the years combined.

SELECT
	SUM(oi.sales) AS total_sales
FROM	
	offuture.order_item oi
LEFT JOIN
	offuture."order" o ON oi.order_id = o.order_id;

-- The order_item table was joined with the order table by the order_id.
-- The years are then extracted from the order_date column and a new column "year" was created.
-- The months are then extracted from the order_date column and a new column "month" was created.
-- The total profit was then calculated by using the SUM function on the profit column.
-- It's then grouped by the created year column and the month column.
-- Finally it was ordered by first the year and then month both in ascending order.
-- This SQL query was created to calculate the total profit per month on each individual year.

SELECT
	EXTRACT(YEAR FROM o.order_date) AS "year",
	EXTRACT(MONTH FROM o.order_date) AS "month",
	SUM(oi.profit) AS total_profit
FROM
	offuture.order_item oi
LEFT JOIN
	offuture."order" o ON oi.order_id = o.order_id
GROUP BY
	EXTRACT(YEAR FROM o.order_date),
	EXTRACT(MONTH FROM o.order_date)
ORDER BY
	"year",
	"month";

-- Calculating the total profit by quarter
-- The order_item table was joined with the order table by the order_id.
-- The years are then extracted from the order_date column and a new column "year" was created.
-- The quarter are then extracted from the order_date column and a new column "quarter" was created.
-- The total profit was then calculated by using the SUM function on the profit column.
-- It's then grouped by the created year column and the quarter column.
-- Finally it was ordered by first the year and then quarter both in ascending order.
-- This SQL query was created to calculate the total profit per quarter on each individual year.

SELECT
	EXTRACT(YEAR FROM o.order_date) AS "year",
	EXTRACT(QUARTER FROM o.order_date) AS "quarter",
	SUM(oi.profit) AS total_profit
FROM
	offuture.order_item oi
LEFT JOIN
	offuture."order" o ON oi.order_id = o.order_id
GROUP BY
	EXTRACT(YEAR FROM o.order_date),
	EXTRACT(QUARTER FROM o.order_date)
ORDER BY
	"year",
	"quarter";

-- The order table was joined to the customer table by the customer_id_short or the customer_id_long.
-- The distinct customer_id was selected to get rid of any duplicates.
-- A where clause was used to filter for where the customer_id_long and the customer_id_short is null.
-- The query was created to find any missing customer ID in the orders search.

SELECT
    DISTINCT(customer_id)
FROM
    offuture.order o
LEFT JOIN offuture.customer c
ON o.customer_id = c.customer_id_short OR
   o.customer_id = c.customer_id_long
WHERE customer_id_long IS NULL
AND customer_id_short IS NULL;

-- The count of the orders was calculated by first joining the order table was joined to the customer table by the customer_id_short or the customer_id_long.
-- Count * was then used to count the rows.

SELECT
    COUNT(*)
FROM
    offuture.order o
INNER JOIN offuture.customer c
ON o.customer_id = c.customer_id_short OR
   o.customer_id = c.customer_id_long;

-- This SQL query creates a view named student.full_customer_arif.
-- It combines data from offuture.customer and offuture.order tables.
-- It then joins customers to orders based on two possible customer ID fields (customer_id_long and customer_id_short).
-- The UNION is used to merge both results, ensuring unique rows by removing duplicates.

CREATE VIEW student.full_customer_arif AS
	(SELECT 
    	*
	FROM 
    	offuture.customer c 
	INNER JOIN 
    	offuture."order" o 
	ON 
    	c.customer_id_long = o.customer_id 
	UNION 
	SELECT 
    	*
	FROM 
    	offuture.customer c 
	INNER JOIN 
    	offuture."order" o 
	ON 
    	c.customer_id_short = o.customer_id
    );

-- This query calculates the number of customer that offuture has.
-- This was done by counting the distinct customer_id_long.

SELECT 
	COUNT(DISTINCT customer_id_long) AS distinct_customer_count
FROM 
	student.full_customer_arif;

-- This query calculates the total countries reached by offuture.
-- This was done by counting the distinct country from the address table.

SELECT
	COUNT(DISTINCT country) AS number_of_countries
FROM
	offuture.address a;

-- This query calculates the average discount given per quarter in 2013, how many discounts were given in those quarters for the category technology.
-- This was done by first joining the order_item table to the product table by the product_id.
-- The order table was then joined to the order_item table using the order_id.
-- Each quarter was then extracted from the order_date column within the order table.
-- A count of all the rows were completed to find the how many discounts were given in that quarter.
-- The average discount was then calculated using the avg function of the discount column of the order_item table.
-- The where clause was then applied to filter the result to only include the category technology and the discount to be more than 0 and to extract only the year 2013.
-- It was then grouped by the quarters which was extracted from the order_date column from the order table.
-- Lastly, it was ordered by the quarters.

SELECT 
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    COUNT(*) AS total_discounted_orders,
    AVG(oi.discount) AS average_discount
FROM 
    offuture.order_item AS oi
JOIN 
    offuture.product AS p ON oi.product_id = p.product_id
JOIN 
    offuture."order" AS o ON oi.order_id = o.order_id
WHERE 
    p.category = 'Technology' 
    AND oi.discount > 0
    AND EXTRACT(YEAR FROM o.order_date) = 2013
GROUP BY 
    EXTRACT(QUARTER FROM o.order_date)
ORDER BY 
    quarter;
   
-- This query calculates the average discount given per quarter in 2013, how many discounts were given in those quarters for the sub_category phones.
-- The only difference from this query from the one above is in the where clause it was filtered by the sub_category phones instead of the category technology.
   
SELECT 
    EXTRACT(QUARTER FROM o.order_date) AS quarter,
    COUNT(*) AS total_discounted_orders,
    AVG(oi.discount) AS average_discount
FROM 
    offuture.order_item AS oi
JOIN 
    offuture.product AS p ON oi.product_id = p.product_id
JOIN 
    offuture."order" AS o ON oi.order_id = o.order_id
WHERE 
	oi.discount > 0
    AND EXTRACT(YEAR FROM o.order_date) = 2013
    AND p.sub_category = 'Phones'
GROUP BY 
    EXTRACT(QUARTER FROM o.order_date)
ORDER BY 
    quarter;

-- This query checks for product in the category technology that were only sold in to 2012.
-- This was done by first joining the product table to the order_item table by the product_id.
-- The order table was then joined to the order_item table using the order_id.
-- Each year was then extracted from the order_date column within the order table.
-- The product_id was then selected from the product table.
-- The product_name was also selected from the product table.
-- The where clause was used to filter the year to 2012 and the category to only technology.
-- It was then grouped by the produc_id first, then the product_name and the year.

SELECT
    EXTRACT(YEAR FROM o.order_date) AS year,
    p.product_id,
    p.product_name
FROM 
    offuture.product AS p
JOIN 
    offuture.order_item AS oi ON p.product_id = oi.product_id
JOIN 
    offuture."order" AS o ON oi.order_id = o.order_id
WHERE 
    EXTRACT(YEAR FROM o.order_date) = 2012
    AND p.category = 'Technology'
GROUP BY 
    p.product_id, 
    p.product_name, 
    EXTRACT(YEAR FROM o.order_date);
   
-- This query calculates how many orders in all the sub_category in the technology category had discounts, the percentage compared to total sold and what are was the average discount for the year 2013 in quarter?
-- Define a CTE to calculate the total number of orders
WITH TotalOrders AS (
    SELECT 
        EXTRACT(QUARTER FROM o.order_date) AS quarter,  -- Extract the quarter from the order date
        p.sub_category,                                  -- Select the sub-category of the product
        COUNT(*) AS total_orders                         -- Count total orders for each sub-category in each quarter
    FROM 
        offuture.order_item AS oi
    JOIN 
        offuture.product AS p ON oi.product_id = p.product_id  -- Join to get product details
    JOIN 
        offuture."order" AS o ON oi.order_id = o.order_id      -- Join to get order details
    WHERE 
        p.category = 'Technology'                           -- Filter for the "Technology" category
        AND EXTRACT(YEAR FROM o.order_date) = 2013          -- Limit results to orders from the year 2013
    GROUP BY 
        EXTRACT(QUARTER FROM o.order_date),                  -- Group by quarter
        p.sub_category                                       -- and by sub-category
)

-- Main query to calculate metrics for discounted orders
SELECT 
    EXTRACT(QUARTER FROM o.order_date) AS quarter,           -- Extract quarter from order date
    p.sub_category,                                          -- Select sub-category of the product
    COUNT(*) AS total_discounted_orders,                     -- Count orders with a discount
    AVG(oi.discount) AS average_discount,                    -- Calculate average discount for discounted orders
    COUNT(*) * 100.0 / t.total_orders AS discount_percentage -- Calculate percentage of discounted orders
FROM 
    offuture.order_item AS oi
JOIN 
    offuture.product AS p ON oi.product_id = p.product_id    -- Join to get product details
JOIN 
    offuture."order" AS o ON oi.order_id = o.order_id        -- Join to get order details
JOIN 
    TotalOrders AS t ON EXTRACT(QUARTER FROM o.order_date) = t.quarter 
                     AND p.sub_category = t.sub_category     -- Join with CTE to get total orders per quarter and sub-category
WHERE 
    p.category = 'Technology'                                -- Filter for "Technology" category
    AND oi.discount > 0                                      -- Only consider orders with a discount
    AND EXTRACT(YEAR FROM o.order_date) = 2013               -- Limit results to the year 2013
GROUP BY 
    EXTRACT(QUARTER FROM o.order_date),                      -- Group by quarter
    p.sub_category,                                          -- and by sub-category
    t.total_orders                                           -- Include total orders from CTE
ORDER BY 
    quarter, p.sub_category;                                 -- Order results by quarter and sub-category

    
    
    
-- Isabelle's Part    
    

-- Define a Common Table Expression (CTE) named complete_customer_order
WITH complete_customer_order AS (
    -- Select all columns from the student.full_customer table
    SELECT 
        *
    FROM 
        student.full_customer_arif fca
    UNION -- Use UNION to combine rows from the student.full_customer table with rows from the "order" and "customer" tables
    -- Select specific columns from customer and order tables to match the structure of full_customer for the UNION
    SELECT -- Selecting columns in the order of the full_customer table to union it
        c.customer_id_short,
        c.customer_id_long,
        c.customer_name,
        c.segment,
        o.order_id,
        o.order_date,
        o.ship_date,
        o.ship_mode,
        o.customer_id,
        o.address_id,
        o.market,
        o.region,
        o.order_priority
    FROM
        offuture."order" o
    LEFT JOIN 
        offuture.customer c -- Left join to include all orders, even those without a matching customer record
    ON 
        o.customer_id = c.customer_id_short OR       -- Match by customer_id_short
        o.customer_id = c.customer_id_long            -- or by customer_id_long
    LEFT JOIN 
        offuture.address a -- Left join to the address table to retrieve the address details
    ON 
        o.address_id = a.address_id
    WHERE 
        c.customer_id_long IS NULL AND c.customer_id_short IS NULL -- Filter to include only orders without matching customers in full_customer
)
-- Step 2: Query the CTE to retrieve all rows from complete_customer_order
SELECT 
    *
FROM 
    complete_customer_order;
    
   
   
   
-- Muhammad's Part   

-- Calculaing margins for phones in each quarter in 2013

SELECT 
    EXTRACT(YEAR FROM fca.order_date) AS full_year,       -- Extracts the year from the order date and labels it as "full_year"
    EXTRACT(QUARTER FROM fca.order_date) AS year_quarter, -- Extracts the quarter from the order date and labels it as "year_quarter"
    p.sub_category,                                       -- Selects the product sub-category
    (SUM(oi.profit) / SUM(oi.sales)) * 100 AS maybe_margin -- Calculates profit margin as a percentage of sales and labels it as "margin"
FROM 
    student.full_customer_arif fca                        -- Uses the full_customer_arif view as the main table
LEFT JOIN 
    offuture.order_item oi ON fca.order_id = oi.order_id  -- Left joins with order_item table to get profit and sales information for each order
LEFT JOIN 
    offuture.product p ON oi.product_id = p.product_id    -- Left joins with product table to get product details like category and sub-category
WHERE 
    p.category = 'Technology'                             -- Filters for only products in the "Technology" category
    AND p.sub_category = 'Phones'                       -- Further filters for only products in the "Machines" sub-category
    AND EXTRACT(YEAR FROM fca.order_date) = '2013'        -- Limits results to orders from the year 2013
GROUP BY 
    EXTRACT(YEAR FROM fca.order_date),                    -- Groups by year to aggregate data at the yearly level
    EXTRACT(QUARTER FROM fca.order_date),                 -- Groups by quarter to aggregate data at the quarterly level
    p.sub_category                                        -- Groups by product sub-category to get metrics specific to "Machines"
ORDER BY 
    EXTRACT(QUARTER FROM fca.order_date);                 -- Orders the results by quarter for chronological display

--Count of all sub_categories with it's corresponding margin for each quarter in 2013

SELECT 
    EXTRACT(YEAR FROM fca.order_date) AS full_year,            -- Extracts the year from the order date and labels it as "full_year"
    EXTRACT(QUARTER FROM fca.order_date) AS year_quarter,      -- Extracts the quarter from the order date and labels it as "year_quarter"
    p.sub_category,                                            -- Selects the product sub-category
    (SUM(oi.profit) / SUM(oi.sales)) * 100 AS margin,    -- Calculates profit margin as a percentage of sales and labels it as "maybe_margin"
    COUNT(*)                                                   -- Counts the number of records for each group
FROM 
    student.full_customer_arif fca                             -- Uses the full_customer_arif view as the main table
LEFT JOIN 
    offuture.order_item oi ON fca.order_id = oi.order_id       -- Left joins with order_item table to get profit and sales information for each order
LEFT JOIN 
    offuture.product p ON oi.product_id = p.product_id         -- Left joins with product table to get product details like category and sub-category
WHERE 
    EXTRACT(YEAR FROM fca.order_date) = '2013'                 -- Filters for orders placed in the year 2013
    AND p.sub_category IN ('Accessories', 'Copiers', 'Machines', 'Phones') -- Filters for specific sub-categories in the product table
GROUP BY 
    EXTRACT(YEAR FROM fca.order_date),                         -- Groups by year to aggregate data at the yearly level
    EXTRACT(QUARTER FROM fca.order_date),                      -- Groups by quarter to aggregate data at the quarterly level
    p.sub_category                                             -- Groups by product sub-category to get metrics specific to each one
ORDER BY 
    p.sub_category,                                            -- Orders the results by sub-category for organized output
    EXTRACT(QUARTER FROM fca.order_date);                      -- Orders by quarter within each sub-category for chronological display


-- This query calculates the sum of sales for all the years
    
SELECT
    EXTRACT(YEAR FROM fca.order_date) AS "year",    -- Extracts the year from the order date
    SUM(oi.sales)                         -- Calculates the total sales for each year
FROM 
    student.full_customer_arif fca        -- Main table containing customer and order information
JOIN 
    offuture.order_item oi ON fca.order_id = oi.order_id  -- Joins with order_item table to get sales information for each order
GROUP BY 
    EXTRACT(YEAR FROM fca.order_date)     -- Groups the results by year to calculate yearly sales totals
ORDER BY 
    EXTRACT(YEAR FROM fca.order_date);    -- Orders the results by year in ascending order for chronological output


-- This query calculates the sum of all sales of each month.
    
SELECT
    EXTRACT(MONTH FROM o.order_date) AS "month",  -- Extracts the month from each order date and labels it as "month"
    SUM(oi.sales) AS total_sales                  -- Calculates the total sales for each month and labels it as "total_sales"
FROM 
    offuture."order" o                            -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Joins with order_item table to link each order with its sales data
GROUP BY 
    EXTRACT(MONTH FROM o.order_date)              -- Groups results by month to calculate total sales for each month
ORDER BY 
    EXTRACT(MONTH FROM o.order_date);             -- Orders results by month in ascending order to display data chronologically

--This query calculates the sum of all sales of each month of each year.

SELECT
    EXTRACT(YEAR FROM o.order_date) AS "year",      -- Extracts the year from each order date and labels it as "year"
    EXTRACT(MONTH FROM o.order_date) AS "month",    -- Extracts the month from each order date and labels it as "month"
    SUM(oi.sales) AS total_sales                  -- Calculates the total sales for each year and month and labels it as "total_sales"
FROM 
    offuture."order" o                            -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Joins with order_item table to link each order with its sales data
GROUP BY 
    EXTRACT(YEAR FROM o.order_date),              -- Groups results by year to calculate yearly sales totals
    EXTRACT(MONTH FROM o.order_date)              -- Groups results by month to calculate monthly sales totals within each year
ORDER BY 
    EXTRACT(YEAR FROM o.order_date),              -- Orders results by year in ascending order for chronological display
    EXTRACT(MONTH FROM o.order_date);             -- Orders results by month in ascending order within each year

-- This query calculates the sum of all sales for each quarter.
    
SELECT
    EXTRACT(QUARTER FROM o.order_date) AS "quarter",  -- Extracts the quarter from each order date (1 to 4) and labels it as "quarter"
    SUM(oi.sales) AS total_sales                      -- Calculates the total sales for each quarter and labels it as "total_sales"
FROM 
    offuture."order" o                                -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Joins with order_item table to link each order with its sales data
GROUP BY 
    EXTRACT(QUARTER FROM o.order_date)                -- Groups results by quarter to calculate total sales for each quarter
ORDER BY 
    EXTRACT(QUARTER FROM o.order_date);               -- Orders results by quarter in ascending order (from Q1 to Q4)

-- This query calculates the sum of all sales of each quarter of each year.
    
SELECT
    EXTRACT(YEAR FROM o.order_date) AS "year",         -- Extracts the year from each order date and labels it as "year"
    EXTRACT(QUARTER FROM o.order_date) AS "quarter",   -- Extracts the quarter from each order date (1 to 4) and labels it as "quarter"
    SUM(oi.sales) AS total_sales                       -- Calculates the total sales for each year and quarter, labeled as "total_sales"
FROM 
    offuture."order" o                                 -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id -- Joins with order_item table to link each order with its sales data
GROUP BY 
    EXTRACT(YEAR FROM o.order_date),                   -- Groups results by year to calculate yearly sales totals
    EXTRACT(QUARTER FROM o.order_date)                 -- Groups results by quarter within each year to calculate quarterly sales totals
ORDER BY 
    EXTRACT(YEAR FROM o.order_date),                   -- Orders results by year in ascending order for chronological display
    EXTRACT(QUARTER FROM o.order_date);                -- Orders results by quarter within each year in ascending order (Q1 to Q4)

-- Top performing products by sales
    
SELECT 
    p.product_name,                          -- Selects the product name from the product table
    SUM(oi.sales) AS total_sales             -- Calculates the total sales for each product and labels it as "total_sales"
FROM 
    offuture.order_item oi                   -- Main table containing order item information with sales data
JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Joins with the product table to link each order item with its product details
GROUP BY 
    p.product_name                           -- Groups results by product name to calculate sales totals for each product
ORDER BY 
    SUM(oi.sales) DESC;                      -- Orders results by total sales in descending order to show the highest-selling products first

-- Top 10 worst performing technology products by profit for each year.

SELECT 
    p.product_name,                              -- Selects the product name from the product table
    p.product_id,                                -- Selects the product ID for unique identification
    EXTRACT(YEAR FROM o.order_date) AS year,     -- Extracts the year from each order date and labels it as "year"
    SUM(oi.profit) AS total_profit               -- Calculates the total profit for each product and year, labeled as "total_profit"
FROM 
    offuture."order" o                           -- Main table containing order information
LEFT JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Left join with order_item table to get profit data for each order
LEFT JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Left join with product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                    -- Filters to include only products in the "Technology" category
GROUP BY 
    p.product_id,                                -- Groups results by product ID to calculate profit totals for each product
    EXTRACT(YEAR FROM o.order_date)              -- Groups results by year to calculate yearly profit totals for each product
ORDER BY 
    SUM(oi.profit) ASC                           -- Orders results by total profit in ascending order to show lowest-profit products first
LIMIT 
    10;                                          -- Limits the result to the top 10 lowest-profit products

--TOP 5 BEST PERFORMING PRODUCTS BY PROFIT ACROSS EACH YEAR
    
SELECT 
    p.product_name,                          -- Selects the product name from the product table
    p.product_id,                            -- Selects the product ID to uniquely identify each product
    SUM(oi.profit) AS total_profit           -- Calculates the total profit for each product and labels it as "total_profit"
FROM 
    offuture."order" o                       -- Main table containing order information
LEFT JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Left joins with order_item table to get profit data associated with each order
LEFT JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Left joins with product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                -- Filters to include only products in the "Technology" category
GROUP BY 
    p.product_id                             -- Groups results by product ID to calculate total profit for each unique product
ORDER BY 
    SUM(oi.profit) DESC                      -- Orders results by total profit in descending order to show highest-profit products first
LIMIT 
    5;                                       -- Limits the output to the top 5 highest-profit products
	
--WORST PERFORMING PRODUCTS BY PROFIT
    
SELECT 
    p.product_name,                          -- Selects the product name from the product table
    SUM(oi.profit) AS total_profit           -- Calculates the total profit for each product and labels it as "total_profit"
FROM 
    offuture.order_item oi                   -- Main table containing order item information with profit data
JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Joins with the product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                -- Filters to include only products in the "Technology" category
GROUP BY 
    p.product_id                             -- Groups results by product ID to calculate total profit for each unique product
ORDER BY 
    SUM(oi.profit);                          -- Orders results by total profit in ascending order, showing lowest-profit products first

--COUNT OF EACH TECH PRODUCTS
    
SELECT 
    p.product_name,                                    -- Selects the product name from the product table
    COUNT(p.product_id) AS total_number_of_product     -- Counts the occurrences of each product ID and labels it as "total_number_of_product"
FROM 
    offuture.order_item oi                             -- Main table containing order item information
JOIN 
    offuture.product p ON oi.product_id = p.product_id -- Joins with the product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                          -- Filters to include only products in the "Technology" category
GROUP BY 
    p.product_id                                       -- Groups results by product ID to count occurrences of each unique product
ORDER BY 
    total_number_of_product DESC;                      -- Orders results by the count of each product in descending order to show the most frequent products first

--COUNT OF HOW MANY TECH PRODUCTS THAT WERE SOLD ACROSS ALL YEARS
    
SELECT 
    COUNT(*) AS total_technology_orders       -- Counts the total number of order items for "Technology" products and labels it as "total_technology_orders"
FROM 
    offuture.order_item oi                    -- Main table containing order item information
JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Joins with the product table to link each order item with its product details
WHERE 
    p.category = 'Technology';                -- Filters to include only products in the "Technology" category
	
--COUNT OF HOW MANY TECH PRODUCTS SOLD THAT HAVE TOTAL PROFIT > 0
    
SELECT
    COUNT(*) AS profitable_technology_orders   -- Counts the total number of profitable order items for "Technology" products and labels it as "profitable_technology_orders"
FROM
    offuture.order_item oi                     -- Main table containing order item information
LEFT JOIN 
    offuture.product p ON p.product_id = oi.product_id  -- Left joins with the product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                  -- Filters to include only products in the "Technology" category
    AND oi.profit > 0;                         -- Filters to include only orders with a positive profit
	
--COUNT OF HOW MANY TECH PRODUCTS SOLD THAT HAVE TOTAL PROFIT <= 0
    
SELECT
    COUNT(*) AS non_profitable_technology_orders  -- Counts the total number of non-profitable order items for "Technology" products and labels it as "non_profitable_technology_orders"
FROM
    offuture.order_item oi                        -- Main table containing order item information
LEFT JOIN 
    offuture.product p ON p.product_id = oi.product_id  -- Left joins with the product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                     -- Filters to include only products in the "Technology" category
    AND oi.profit <= 0;                           -- Filters to include only orders with zero or negative profit

--COUNT OF PRODUCTS THAT WERE ONLY SOLD IN YYYY
  
SELECT 
    COUNT(DISTINCT p.product_id) AS unique_technology_products  -- Counts the distinct product IDs in the "Technology" category, labeled as "unique_technology_products"
FROM 
    offuture."order" o                                         -- Main table containing order information
LEFT JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id         -- Left joins with order_item table to link each order with its items
LEFT JOIN 
    offuture.product p ON oi.product_id = p.product_id         -- Left joins with product table to link each order item with its product details
WHERE 
    p.category = 'Technology'                                  -- Filters to include only products in the "Technology" category
    AND EXTRACT(YEAR FROM o.order_date) NOT IN ('2011', '2014', '2013'); -- Filters to include only orders placed in years other than 2011, 2014, and 2013

--SUM across YEARS by category

SELECT
    p.category,                                      -- Selects the product category from the product table
    EXTRACT(YEAR FROM o.order_date) AS "year",       -- Extracts the year from each order date and labels it as "year"
    SUM(oi.profit) AS total_profit                   -- Calculates the total profit for each category and year, labeled as "total_profit"
FROM 
    offuture."order" o                               -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Joins with the order_item table to link each order with its profit data
JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Joins with the product table to link each order item with its product category
GROUP BY 
    p.category,                                      -- Groups results by product category to calculate profit for each category
    EXTRACT(YEAR FROM o.order_date)                  -- Groups results by year to calculate yearly profit for each category
ORDER BY 
    EXTRACT(YEAR FROM o.order_date),                 -- Orders results by year in ascending order for chronological display
    total_profit DESC;                               -- Orders results by total profit in descending order within each year to show the most profitable categories first

--SUM across YEARS by sub_category
    
SELECT
    p.sub_category,                                  -- Selects the product sub-category from the product table
    EXTRACT(YEAR FROM o.order_date) AS year,         -- Extracts the year from each order date and labels it as "year"
    SUM(oi.sales) AS total_sales                     -- Calculates the total sales for each sub-category and year, labeled as "total_sales"
FROM 
    offuture."order" o                               -- Main table containing order information
JOIN 
    offuture.order_item oi ON o.order_id = oi.order_id  -- Joins with the order_item table to link each order with its sales data
JOIN 
    offuture.product p ON oi.product_id = p.product_id  -- Joins with the product table to link each order item with its product sub-category
GROUP BY 
    p.sub_category,                                  -- Groups results by product sub-category to calculate sales for each sub-category
    EXTRACT(YEAR FROM o.order_date)                  -- Groups results by year to calculate yearly sales for each sub-category
ORDER BY 
    EXTRACT(YEAR FROM o.order_date),                 -- Orders results by year in ascending order for chronological display
    total_sales DESC;                                -- Orders results by total sales in descending order within each year to show the highest sales first

--SUM across YEARS by segment
    
SELECT
    fca.segment,                                      -- Selects the customer segment from the full_customer_arif table
    EXTRACT(YEAR FROM fca.order_date) AS "year",      -- Extracts the year from each order date and labels it as "year"
    SUM(oi.sales) AS total_sales                      -- Calculates the total sales for each segment and year, labeled as "total_sales"
FROM 
    student.full_customer_arif fca                    -- Main table containing customer and order information
JOIN 
    offuture.order_item oi ON fca.order_id = oi.order_id  -- Joins with the order_item table to link each order with its sales data
GROUP BY 
    fca.segment,                                      -- Groups results by customer segment to calculate sales for each segment
    EXTRACT(YEAR FROM fca.order_date)                 -- Groups results by year to calculate yearly sales for each segment
ORDER BY 
    EXTRACT(YEAR FROM fca.order_date),                -- Orders results by year in ascending order for chronological display
    fca.segment;                                      -- Orders results alphabetically by segment within each year