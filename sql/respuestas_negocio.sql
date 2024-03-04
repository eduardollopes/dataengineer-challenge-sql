-- ##################################################################################
-- 1.)  Listar os usuários que fazem aniversário hoje e cujo 
--      total de vendas realizadas em janeiro de 2020 seja superior a 1500. 
-- ##################################################################################

-- Uma CTE foi criada com foco na performance da execução da consulta
WITH temp_sales_2020 AS (
    SELECT 
        customer_id,
        SUM(total_order) AS sum_total_order
    FROM `Order`
    WHERE strftime('%Y-%m', order_date) = '2020-01' -- Cláusula para considerar as vendas em janeiro de 2020
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.sum_total_order
FROM Customer c
INNER JOIN Seller s           ON c.customer_id = s.customer_id    -- Join para identificar clientes que são vendedores.
INNER JOIN temp_sales_2020 o  ON s.customer_id = o.customer_id    -- Join necessário para associar os pedidos (vendas) feitos pelos clientes vendedores.
WHERE strftime('%m-%d', c.birth_date) = strftime('%m-%d', 'now')  -- Cláusula para filtrar os aniversariantes do dia                
GROUP BY c.customer_id
HAVING o.sum_total_order > 1500;


-- ############################################################################################################
-- 2.)  Para cada mês de 2020, é solicitado o top 5 de usuários que mais venderam ($) na categoria Celulares. 
--      São necessários o mês e ano de análise, nome e sobrenome do vendedor, quantidade de vendas realizadas, 
--      quantidade de produtos vendidos e o montante total transacionado. 
-- ############################################################################################################

-- Foi criada uma CTE com foco na performance da execução da consulta 
WITH TopSellers AS (
    -- A seguinte consulta recupera informações sobre os principais vendedores de celulares em cada mês de 2020.
    SELECT
        strftime('%Y-%m', ord.order_date) AS month_year,
        cus.customer_id,
        cus.first_name,
        cus.last_name,
        COUNT(DISTINCT ord.order_id) AS sales_count,
        COUNT(itord.item_id) AS products_sold,
        SUM(itord.unit_price * itord.quantity) AS total_transaction
    FROM `Order`    ord
    JOIN ItemOrder  itord   ON ord.order_id = itord.order_id     -- Join na tabela ItemOrder para associar pedidos a itens e suas quantidades.
    JOIN Item       it      ON itord.item_id = it.item_id        -- Join na tabela Item para obter informações sobre itens associados aos pedidos.
    JOIN Category   cat     ON it.category_id = cat.category_id  -- Join na tabela Category para filtrar vendas na categoria "Celulares".
    JOIN Seller     sel     ON ord.customer_id = sel.customer_id -- Join na tabela Seller para identificar clientes que também são vendedores.
    JOIN Customer   cus     ON sel.customer_id = cus.customer_id -- Join na tabela Customer para obter informações sobre os vendedores.
    WHERE strftime('%Y', ord.order_date) = '2020'                -- Cláusula para considerar vendas em 2020.
    AND cat.description = 'Celulares'                            -- Filtrando vendas para a categoria "Celulares".
    GROUP BY month_year, cus.customer_id
)
-- A seguinte consulta filtra e classifica os 5 principais vendedores em cada mês com base no montante total da transação.
SELECT *
FROM (
    -- Explicação: A subconsulta calcula as classificações para cada vendedor dentro de cada mês.
    SELECT
        month_year,
        first_name,
        last_name,
        sales_count,
        products_sold,
        total_transaction,
        ROW_NUMBER() OVER (PARTITION BY month_year ORDER BY total_transaction DESC) AS rank -- Função de janela para criar uma classificação de vendas.
    FROM TopSellers
) ranked_sellers
WHERE rank <= 5 -- Filtrando o resultado final para incluir apenas os 5 principais vendedores em cada mês.
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
