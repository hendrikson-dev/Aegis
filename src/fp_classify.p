DEFINE INPUT PARAMETER iCustNum AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER cSegment  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER dScore AS DECIMAL NO-UNDO.

DEFINE VARIABLE iOrderCount AS INTEGER NO-UNDO.
DEFINE VARIABLE dTotalSpend AS DECIMAL NO-UNDO.

cSegment = 'New'.
dScore = 0.  

FIND fp_Customer WHERE
fp_Customer.CustNum = iCustNum NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Customer THEN
DO:
    cSegment = 'Unknown'.
    RETURN.
END.

FOR EACH fp_Booking WHERE fp_Booking.CustNum = iCustNum NO-LOCK:
    iOrderCount = iOrderCount + 1.
    dTotalSpend = dTotalSpend + fp_Booking.PricePaid.
END.

FOR EACH fp_Segment NO-LOCK BY fp_Segment.MinOrders DESCENDING:
IF iOrderCount >= fp_Segment.MinOrders
   AND dTotalSpend >= fp_Segment.MinSpend THEN DO:
    cSegment = fp_Segment.SegName.
    LEAVE.
   END.
END.

dScore = MINIMUM(100, iOrderCount * 10 + dTotalSpend / 100).
