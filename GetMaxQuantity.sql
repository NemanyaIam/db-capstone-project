-- Ensure you're using the correct database
USE little_lemon_db;

-- Change the delimiter to avoid conflict with the semicolons inside the procedure
DELIMITER //

-- Drop the existing GetMaxQuantity procedure if it exists
DROP PROCEDURE IF EXISTS GetMaxQuantity//

-- Create the GetMaxQuantity procedure
CREATE PROCEDURE GetMaxQuantity()
BEGIN
    SELECT MAX(quantity) AS MaxQuantity
    FROM orders;
END//

-- Reset the delimiter back to semicolon
DELIMITER ;