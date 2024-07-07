-- Ensure you're using the correct database
USE little_lemon_db;

-- Create the prepared statement
PREPARE GetOrderDetail FROM
'SELECT orders_id AS OrderID, quantity AS Quantity, total_cost AS Cost 
 FROM orders 
 WHERE customer_id = ?';

-- Declare a variable to hold the CustomerID
SET @id = 1;

-- Execute the prepared statement using the variable
EXECUTE GetOrderDetail USING @id;

-- Optionally, you can deallocate the prepared statement to free up resources
DEALLOCATE PREPARE GetOrderDetail;