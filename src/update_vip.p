FIND fp_Segment WHERE fp_Segment.SegName = 'VIP' EXCLUSIVE-LOCK NO-ERROR.

IF AVAILABLE fp_Segment THEN DO:
    ASSIGN fp_Segment.MinSpend = 7000.
    MESSAGE 'Success! VIP MinSpend is now 7000.' VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
    MESSAGE 'VIP segment not found.' VIEW-AS ALERT-BOX ERROR.
END.
