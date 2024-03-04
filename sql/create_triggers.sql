-- Conteúdo do arquivo create_triggers.sql
-- Cria um gatilho para inserção na tabela HistoryUpdateItems após cada inserção na tabela Item
CREATE TRIGGER after_item_insert
AFTER INSERT ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, NULL, NULL, 'INSERT', CURRENT_TIMESTAMP);
END;

-- Cria um gatilho para atualizar a tabela HistoryUpdateItems após cada atualização na tabela Item
CREATE TRIGGER after_item_update
AFTER UPDATE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, OLD.price, OLD.status, 'UPDATE', CURRENT_TIMESTAMP);
END;

-- Cria um gatilho de exclusão na tabela HistoryUpdateItems após cada exclusão na tabela Item
CREATE TRIGGER after_item_delete
AFTER DELETE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (OLD.item_id, OLD.price, OLD.status, 'DELETE', CURRENT_TIMESTAMP);
END;
