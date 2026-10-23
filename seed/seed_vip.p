

FIND fp_Segment WHERE fp_Segment.SegName = 'VIP' NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Segment THEN DO:
    CREATE fp_Segment.
    ASSIGN fp_Segment.SegName = 'VIP'
           fp_Segment.DiscountPct = 15
           fp_Segment.FloorPct = 99
           fp_Segment.MinOrders = 15
           fp_Segment.MinSpend = 100000.
    IF AVAILABLE fp_Segment THEN
        DISPLAY 'SUCCESS: VIP row created'.
    ELSE
        DISPLAY 'FAILED: CREATE did not produce a usable row'.
END.
ELSE
    DISPLAY 'VIP already exists'.   
