DEFINE VARIABLE iWho        AS INTEGER NO-UNDO.
DEFINE VARIABLE iBookCount  AS INTEGER NO-UNDO.
DEFINE VARIABLE cBehaviour  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOut        AS CHARACTER NO-UNDO.



cOut = ''.

DO iWho = 1001 TO 1003:
    FIND fp_Customer WHERE fp_Customer.CustNum = iWho NO-LOCK NO-ERROR.
    IF NOT AVAILABLE fp_Customer THEN DO:
        cOut = cOut + STRING(iWho) + '  NOT FOUND' + CHR(10).
        NEXT.
    END.

    iBookCount = 0.
    FOR EACH fp_Booking WHERE fp_Booking.CustNum = iWho NO-LOCK:
        iBookCount = iBookCount + 1.
    END.

    cBehaviour = 'None'.
    FIND FIRST fp_Behaviour WHERE fp_Behaviour.CustNum = iWho NO-LOCK NO-ERROR.
    IF AVAILABLE fp_Behaviour THEN
        cBehaviour = fp_Behaviour.BehaviourCode + ' risk ' + STRING(fp_Behaviour.RiskLevel).

    cOut = cOut + STRING(iWho) + '  ' + fp_Customer.Name
         + '  bookings=' + STRING(iBookCount)
         + '  behaviour=' + cBehaviour + CHR(10).
END.

MESSAGE cOut VIEW-AS ALERT-BOX INFORMATION TITLE 'Demo customer check'.
