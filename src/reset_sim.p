FOR EACH fp_Booking WHERE fp_Booking.BookingNum >= 10000 EXCLUSIVE-LOCK:
    DELETE fp_Booking.
END.

FOR EACH fp_Behaviour WHERE fp_Behaviour.BehaviourID >= 1000 EXCLUSIVE-LOCK:
    DELETE fp_Behaviour.
END.

FOR EACH fp_Credit WHERE fp_Credit.CustNum >= 1000 EXCLUSIVE-LOCK:
    DELETE fp_Credit.
END.

FOR EACH fp_Customer WHERE fp_Customer.CustNum >= 1000 EXCLUSIVE-LOCK:
    DELETE fp_Customer.
END.

MESSAGE 'Simulated data removed (including credit).' 
    VIEW-AS ALERT-BOX INFORMATION.
