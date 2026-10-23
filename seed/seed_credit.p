

FOR EACH fp_Credit WHERE fp_Credit.CustNum <= 3 EXCLUSIVE-LOCK:
    DELETE fp_Credit.
END.

CREATE fp_Credit.
ASSIGN fp_Credit.CreditID      = 1
       fp_Credit.CustNum       = 1
       fp_Credit.Amount        = 80.00
       fp_Credit.IssuedDate    = TODAY
       fp_Credit.ExpiryDate    = TODAY + 365
       fp_Credit.CreditState   = 'Open'
       fp_Credit.SourceBooking = 1.

CREATE fp_Credit.
ASSIGN fp_Credit.CreditID      = 2
       fp_Credit.CustNum       = 2
       fp_Credit.Amount        = 80.00
       fp_Credit.IssuedDate    = TODAY - 400
       fp_Credit.ExpiryDate    = TODAY - 1
       fp_Credit.CreditState   = 'Open'
       fp_Credit.SourceBooking = 4.

MESSAGE 'Credit seed complete. C1 = R80 open, C2 = expired, C3 = none.'
    VIEW-AS ALERT-BOX INFORMATION.
