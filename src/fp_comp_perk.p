DEFINE INPUT  PARAMETER iCustNum    AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER iBookingNum AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dValue      AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dListPrice  AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER bLastSeat   AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER cFairness   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER dComp       AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cPerk       AS CHARACTER NO-UNDO.

DEFINE VARIABLE cSegment AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScore   AS DECIMAL   NO-UNDO.

dComp = 0.
cPerk = 'None'.

FIND fp_Booking WHERE fp_Booking.BookingNum = iBookingNum
                  AND fp_Booking.CustNum = iCustNum NO-LOCK NO-ERROR.

IF AVAILABLE fp_Booking THEN
    dComp = ROUND(MAXIMUM(0, fp_Booking.PricePaid - dValue), 2).

IF cFairness = 'RELEASE' THEN DO:
    RUN fp_classify.p (INPUT iCustNum, OUTPUT cSegment, OUTPUT dScore).
    
    IF cSegment = 'Loyal' OR cSegment = 'VIP' THEN
        cPerk = 'Seat upgrade'.
    ELSE IF bLastSeat THEN
        cPerk = 'Voucher'.
END.
