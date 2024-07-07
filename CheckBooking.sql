DELIMITER //

CREATE PROCEDURE CheckBooking (
    IN booking_date DATE,
    IN table_number INT
)
BEGIN
    DECLARE table_status VARCHAR(50);

    -- Check if the table is booked on the given date
    SELECT 
        CASE 
            WHEN EXISTS (
                SELECT * 
                FROM bookings 
                WHERE booking_date = booking_date 
                AND table_number = table_number
            )
            THEN 'Booked'
            ELSE 'Available'
        END INTO table_status;

    -- Return the status of the table
    SELECT table_status AS TableStatus;
END //

DELIMITER ;