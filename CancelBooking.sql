DELIMITER //

CREATE PROCEDURE CancelBooking(IN booking_id INT)
BEGIN
    DECLARE booking_exists INT;
    
    -- Check if the booking_id exists
    SELECT COUNT(*) INTO booking_exists
    FROM bookings
    WHERE booking_id = booking_id;
    
    -- If booking exists, delete it
    IF booking_exists > 0 THEN
        DELETE FROM bookings
        WHERE booking_id = booking_id;
        
        SELECT CONCAT('Booking with ID ', booking_id, ' has been successfully cancelled.') AS Message;
    ELSE
        SELECT 'Booking ID does not exist.' AS Message;
    END IF;
    
END //

DELIMITER ;