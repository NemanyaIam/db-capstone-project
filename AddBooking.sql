DELIMITER //

CREATE PROCEDURE AddBooking (
    IN table_number INT,
    IN booking_date DATE,
    IN customer_id INT
)
BEGIN
    INSERT INTO bookings (table_number, booking_date, customer_id)
    VALUES (table_number, booking_date, customer_id);
    
    SELECT 'Booking added successfully' AS Message;
END //

DELIMITER ;