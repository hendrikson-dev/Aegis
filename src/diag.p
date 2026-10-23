DEFINE VARIABLE iOrders AS INTEGER NO-UNDO.
DEFINE VARIABLE dSpend  AS DECIMAL  NO-UNDO.

FOR EACH fp_Segment NO-LOCK BY fp_Segment.SegName:
    PUT UNFORMATTED fp_Segment.SegName + ' | orders ' +
STRING(fp_Segment.MinOrders)
        + ' | spend ' + STRING(fp_Segment.MinSpend) SKIP.
END.
FOR EACH fp_Customer NO-LOCK:
    ASSIGN iOrders = 0 dSpend = 0.
    FOR EACH fp_Booking WHERE fp_Booking.CustNum = fp_Customer.CustNum NO-LOCK:
        ASSIGN iOrders = iOrders + 1    dSpend = dSpend + fp_Booking.PricePaid.
    END.
    PUT UNFORMATTED 'Customer ' + STRING(fp_Customer.CustNum) + ' | bookings '
        + STRING(iOrders) + ' | spent ' + STRING(dSpend) SKIP.
END.
