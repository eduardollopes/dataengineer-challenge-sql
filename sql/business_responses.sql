-- ##################################################################################
-- 1.)  Listar los usuarios que cumplan años el día de hoy cuya 
--      cantidad de ventas realizadas en enero 2020 sea superior a 1500. 
-- ##################################################################################

-- A CTE was created with query execution performance in mind 
WITH temp_sales_2020 as (
    SELECT 
        customer_id,
        sum(total_order) as sum_total_order
    FROM `Order`
    WHERE strftime('%Y-%m', order_date) = '2020-01' -- Clause to take sales in January/2020
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.sum_total_order
FROM Customer c
INNER JOIN Seller s           ON c.customer_id = s.customer_id          -- This join is to identify customers who are sellers.
INNER JOIN temp_sales_2020 o  ON s.customer_id = o.customer_id          -- This join is necessary to associate the orders (sales) made by the selling customers.
WHERE strftime('%m-%d', c.birth_date) = strftime('%m-%d', 'now')  -- Clause to filter the day's birthdays                
GROUP BY c.customer_id
HAVING o.sum_total_order > 1500;

-- ##################################################################################
-- 2.)  Por cada mes del 2020, se solicita el top 5 de usuarios que más 
--      vendieron($) en la categoría Celulares. Se requiere el mes y año 
--      de análisis, nombre y apellido del vendedor, cantidad de ventas 
--      realizadas, cantidad de productos vendidos y el monto total transaccionado. 
-- ##################################################################################

-- A CTE was created with query execution performance in mind 
WITH TopSellers AS (
    -- The following query retrieves information about the top sellers of cell phones in each month of 2020.
    SELECT
        strftime('%Y-%m', ord.order_date) AS month_year,
        cus.customer_id,
        cus.first_name,
        cus.last_name,
        COUNT(DISTINCT ord.order_id) AS sales_count,
        COUNT(itord.item_id) AS products_sold,
        SUM(itord.unit_price * itord.quantity) AS total_transaction
    FROM `Order`    ord
    JOIN ItemOrder  itord   ON ord.order_id = itord.order_id     -- Join with ItemOrder table to associate orders with items and their quantities.
    JOIN Item       it      ON itord.item_id = it.item_id        -- Join with Item table to retrieve info about items associated with the orders.
    JOIN Category   cat     ON it.category_id = cat.category_id  -- Join with Category table to filter sales in the "Celulares" category.
    JOIN Seller     sel     ON ord.customer_id = sel.customer_id -- Join with Seller table to identify customers who are also sellers.
    JOIN Customer   cus     ON sel.customer_id = cus.customer_id -- Join with Customer table to get info about the sellers.
    WHERE strftime('%Y', ord.order_date) = '2020'                -- Clause to take sales in 2020.
    AND cat.description = 'Celulares'                            -- Filtering sales to the "Celulares" category
    GROUP BY month_year, cus.customer_id
)
-- The following query filters and ranks the top 5 sellers in each month based on total transaction amount.
SELECT
    month_year,
    first_name,
    last_name,
    sales_count,
    products_sold,
    total_transaction
FROM (
    -- Explanation: The subquery calculates the rankings for each seller within each month.
    SELECT
        month_year,
        first_name,
        last_name,
        sales_count,
        products_sold,
        total_transaction,
        ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY total_transaction DESC) AS rank -- Window function no create a ranking of salles
    FROM TopSellers
) ranked_sellers
WHERE rank <= 5 -- Filtering the final result to include only the top 5 sellers in each month.
ORDER BY month_year, total_transaction;


-- ##################################################################################
-- 3.)  Se solicita poblar una nueva tabla con el precio y estado de los 
--      Ítems a fin del día. Tener en cuenta que debe ser reprocesable. 
--      Vale resaltar que en la tabla Item, vamos a tener únicamente el 
--      último estado informado por la PK definida. 
--      (Se puede resolver a través de StoredProcedure) 
-- ##################################################################################

-- Trigger to capture history updates after inserting a new record into the Item table
CREATE TRIGGER after_item_insert
AFTER INSERT ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, NULL, NULL, 'INSERT', CURRENT_TIMESTAMP);
END;

-- Trigger to capture history updates after updating a record in the Item table
CREATE TRIGGER after_item_update
AFTER UPDATE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, OLD.price, OLD.status, 'UPDATE', CURRENT_TIMESTAMP);
END;

-- Trigger to capture history updates after deleting a record from the Item table
CREATE TRIGGER after_item_delete
AFTER DELETE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (OLD.item_id, OLD.price, OLD.status, 'DELETE', CURRENT_TIMESTAMP);
END;
