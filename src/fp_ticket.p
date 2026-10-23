DEFINE INPUT  PARAMETER iCustNum      AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER iBookingNum   AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dValue        AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dListPrice    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dMarginalCost AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER bLastSeat     AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER dOccupancy    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dHoursLeft    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dWindow       AS DECIMAL   NO-UNDO.

DEFINE VARIABLE cName          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSegment       AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScore         AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cFairness      AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFinalPrice    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cReason        AS CHARACTER NO-UNDO.
DEFINE VARIABLE dComp          AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cPerk          AS CHARACTER NO-UNDO.
DEFINE VARIABLE dBlocked       AS DECIMAL   NO-UNDO.

FIND fp_Customer WHERE fp_Customer.CustNum = iCustNum NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Customer THEN DO:
    PUT UNFORMATTED 'Customer ' + STRING(iCustNum) + ' was not found.' SKIP.
    RETURN.
END.

cName = fp_Customer.Name.

RUN fp_decide.p (INPUT iCustNum, INPUT iBookingNum, INPUT dListPrice,
                 INPUT dMarginalCost, INPUT bLastSeat,
                 INPUT dOccupancy, INPUT dHoursLeft, INPUT dWindow,
                 OUTPUT cSegment, OUTPUT dScore, OUTPUT cFairness,
                 OUTPUT dFinalPrice, OUTPUT dComp, OUTPUT cPerk,
                 OUTPUT dBlocked, OUTPUT cReason).

DISPLAY 
    iCustNum       LABEL "Cust#"     FORMAT "99"
    cName          LABEL "Customer"  FORMAT "x(20)"
    cSegment       LABEL "Segment"   FORMAT "x(10)"
    cFairness      LABEL "Fairness"  FORMAT "x(10)"
    dFinalPrice    LABEL "Price"     FORMAT ">>>,>>9.99"
    dComp          LABEL "Comp"      FORMAT ">>>,>>9.99"
    cPerk          LABEL "Perk"      FORMAT "x(15)"
    cReason        LABEL "Reason"    FORMAT "x(70)"
    WITH FRAME ticket_frame.
