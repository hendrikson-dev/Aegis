DEFINE INPUT  PARAMETER iCustNum AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER dBalance AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dToday AS DATE NO-UNDO.

dBalance = 0.
dToday = TODAY.

FOR EACH fp_Credit WHERE fp_Credit.CustNum     = iCustNum
                     AND fp_Credit.CreditState  = 'Open'
                     NO-LOCK:
    IF fp_Credit.ExpiryDate < dToday THEN NEXT.
    dBalance = dBalance + fp_Credit.Amount.
END.
