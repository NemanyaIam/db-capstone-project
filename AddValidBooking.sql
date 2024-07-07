DELIMITER //

CREATE PROCEDURE AddValidBooking (
    IN booking_date DATE,
    IN table_number INT,
    IN customer_id INT
)
BEGIN
    DECLARE table_status VARCHAR(50);

    -- Start a transaction
    START TRANSACTION;

    -- Check if the table is already booked on the given date
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

    -- If the table is already booked, rollback the transaction
    IF table_status = 'Booked' THEN
        ROLLBACK;
        SELECT 'Table is already booked' AS Message;
    ELSE
        -- Otherwise, insert the new booking record
        INSERT INTO bookings (booking_date, table_number, customer_id)
        VALUES (booking_date, table_number, customer_id);

        -- Commit the transaction
        COMMIT;
        SELECT 'Booking added successfully' AS Message;
    END IF;
END //

DELIMITER ;