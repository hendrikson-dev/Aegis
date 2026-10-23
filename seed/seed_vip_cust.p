

FIND fp_Customer WHERE fp_Customer.CustNum = 9 NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Customer THEN DO:
    CREATE fp_Customer.
    ASSIGN fp_Customer.CustNum = 9
           fp_Customer.Name = 'Test VIP'.
END.

DEFINE VARIABLE i AS INTEGER NO-UNDO.
DO i = 1 TO 16:
    CREATE fp_Booking.
    ASSIGN fp_Booking.BookingNum = 100 + i
           fp_Booking.CustNum    = 9
           fp_Booking.PricePaid  = 10000.
END.

DISPLAY 'VIP customer 9 seeded: 16 bookings x R10,000'.   
