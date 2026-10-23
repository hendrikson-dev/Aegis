/* seed_day4.p */
FOR EACH fp_Behaviour EXCLUSIVE-LOCK: DELETE fp_Behaviour. END.
FOR EACH fp_Booking WHERE fp_Booking.BookingNum >= 4 EXCLUSIVE-LOCK:
    DELETE fp_Booking.
END.

FIND fp_Customer WHERE fp_Customer.CustNum = 3 NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Customer THEN DO:
    CREATE fp_Customer.
    ASSIGN fp_Customer.CustNum = 3
           fp_Customer.Name = 'Customer Three'
           fp_Customer.RegDate = TODAY.
END.

CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 4 fp_Booking.CustNum = 2
       fp_Booking.PricePaid = 500.
CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 5 fp_Booking.CustNum = 2
       fp_Booking.PricePaid = 500.
CREATE fp_Booking.
ASSIGN fp_Booking.BookingNum = 6 fp_Booking.CustNum = 2
       fp_Booking.PricePaid = 500.

CREATE fp_Behaviour.
ASSIGN fp_Behaviour.BehaviourID = 1
       fp_Behaviour.CustNum = 1
       fp_Behaviour.ActiveStatus = 'Active'
       fp_Behaviour.BookingBehaviour = 'ViewedThenLeft'
       fp_Behaviour.RiskLevel = 0
       fp_Behaviour.BehaviourCode = 'VIEWED_THEN_LEFT'
       fp_Behaviour.Description = 'Saw the higher price, left, came back after the drop'.

CREATE fp_Behaviour.
ASSIGN fp_Behaviour.BehaviourID = 2
       fp_Behaviour.CustNum = 2
       fp_Behaviour.ActiveStatus = 'Active'
       fp_Behaviour.BookingBehaviour = 'WaitedForDrop'
       fp_Behaviour.RiskLevel = 2
       fp_Behaviour.BehaviourCode = 'NEVER_VIEWED_HIGH'
       fp_Behaviour.Description = 'Never viewed the higher price, booked only after the drop'.   
