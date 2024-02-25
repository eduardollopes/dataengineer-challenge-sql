-- Contents of the file create_triggers.sql
-- Create a trigger for insertion into the HistoryUpdateItems table after each insertion into the Item table
CREATE TRIGGER after_item_insert
AFTER INSERT ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, NULL, NULL, 'INSERT', CURRENT_TIMESTAMP);
END;

-- Create a trigger to update the HistoryUpdateItems table after each update to the Item table
CREATE TRIGGER after_item_update
AFTER UPDATE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (NEW.item_id, OLD.price, OLD.status, 'UPDATE', CURRENT_TIMESTAMP);
END;

-- Create a delete trigger in the HistoryUpdateItems table after each delete in the Item table
CREATE TRIGGER after_item_delete
AFTER DELETE ON Item
FOR EACH ROW
BEGIN
    INSERT INTO HistoryUpdateItems (item_id, previous_price, previous_status, operation_type, update_date)
    VALUES (OLD.item_id, OLD.price, OLD.status, 'DELETE', CURRENT_TIMESTAMP);
END;
