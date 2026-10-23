DEFINE INPUT PARAMETER iCustNum    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER iBookingNum AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER dAmount     AS DECIMAL NO-UNDO.

DEFINE VARIABLE iNextCredit AS INTEGER NO-UNDO INITIAL 1.

IF dAmount <= 0 THEN RETURN.

FOR EACH fp_Credit NO-LOCK:
    IF fp_Credit.CreditID >= iNextCredit THEN
        iNextCredit = fp_Credit.CreditID + 1.
END.

CREATE fp_Credit.
ASSIGN fp_Credit.CreditID      = iNextCredit
       fp_Credit.CustNum       = iCustNum
       fp_Credit.Amount        = dAmount
       fp_Credit.IssuedDate    = TODAY
       fp_Credit.ExpiryDate    = TODAY + 365
       fp_Credit.CreditState   = 'Open'
       fp_Credit.SourceBooking = iBookingNum.
