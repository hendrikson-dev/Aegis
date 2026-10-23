DEFINE VARIABLE iNext AS INTEGER NO-UNDO INITIAL 1.
DEFINE VARIABLE iB    AS INTEGER NO-UNDO.

FOR EACH fp_Behaviour WHERE fp_Behaviour.CustNum >= 1001 AND fp_Behaviour.CustNum <= 1003 EXCLUSIVE-LOCK:
    DELETE fp_Behaviour.
END.
FOR EACH fp_Booking WHERE fp_Booking.CustNum >= 1001 AND fp_Booking.CustNum <= 1003 EXCLUSIVE-LOCK:
    DELETE fp_Booking.
END.

FIND fp_Customer WHERE fp_Customer.CustNum = 1001 EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE fp_Customer THEN ASSIGN fp_Customer.Name = 'Thandi Mokoena'.

FIND fp_Customer WHERE fp_Customer.CustNum = 1002 EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE fp_Customer THEN ASSIGN fp_Customer.Name = 'Sipho Ndlovu'.

FIND fp_Customer WHERE fp_Customer.CustNum = 1003 EXCLUSIVE-LOCK NO-ERROR.
IF AVAILABLE fp_Customer THEN ASSIGN fp_Customer.Name = 'Lerato Dlamini'.

DO iB = 1 TO 6:
    CREATE fp_Booking.
    ASSIGN fp_Booking.BookingNum = 19000 + iB
           fp_Booking.CustNum    = (IF iB <= 3 THEN 1001 ELSE 1002)
           fp_Booking.PricePaid  = 500
           fp_Booking.BookDate   = TODAY.
END.

FOR EACH fp_Behaviour NO-LOCK:
    IF fp_Behaviour.BehaviourID >= iNext THEN iNext = fp_Behaviour.BehaviourID + 1.
END.

CREATE fp_Behaviour.
ASSIGN fp_Behaviour.BehaviourID      = iNext
       fp_Behaviour.CustNum          = 1001
       fp_Behaviour.ActiveStatus     = 'Active'
       fp_Behaviour.BookingBehaviour = 'ViewedThenLeft'
       fp_Behaviour.RiskLevel        = 0
       fp_Behaviour.BehaviourCode    = 'VIEWED_THEN_LEFT'
       fp_Behaviour.Description      = 'Demo: saw the higher price and left'.

CREATE fp_Behaviour.
ASSIGN fp_Behaviour.BehaviourID      = iNext + 1
       fp_Behaviour.CustNum          = 1002
       fp_Behaviour.ActiveStatus     = 'Active'
       fp_Behaviour.BookingBehaviour = 'WaitedForDrop'
       fp_Behaviour.RiskLevel        = 2
       fp_Behaviour.BehaviourCode    = 'NEVER_VIEWED_HIGH'
       fp_Behaviour.Description      = 'Demo: never viewed the higher price, waited'.

MESSAGE 'Demo customers seeded (Thandi, Sipho, Lerato).'
    VIEW-AS ALERT-BOX INFORMATION.
