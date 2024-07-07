-- Ensure you're using the correct database
USE little_lemon_db;

-- Create the stored procedure
DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id INT)
BEGIN
    DELETE FROM orders WHERE orders_id = order_id;
END //
DELIMITER ;

-- Call the stored procedure with a specific order ID
CALL CancelOrder(1);