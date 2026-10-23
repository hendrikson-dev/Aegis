DEFINE INPUT  PARAMETER iCustNum      AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER iBookingNum   AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dListPrice    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dMarginalCost AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER bLastSeat     AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER dOccupancy    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dHoursLeft    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dWindow       AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cSegment      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER dScore        AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cFairness     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER dFinalPrice   AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER dComp         AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cPerk         AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER dBlocked      AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cReason       AS CHARACTER NO-UNDO.

DEFINE VARIABLE dWouldBe       AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFloorForBlock AS DECIMAL NO-UNDO.
DEFINE VARIABLE iPropID        AS INTEGER NO-UNDO.

RUN fp_classify.p (INPUT iCustNum, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iCustNum, OUTPUT cFairness).
RUN fp_price.p    (INPUT iCustNum, INPUT dListPrice, INPUT dMarginalCost,
                   INPUT dOccupancy, INPUT dHoursLeft, INPUT dWindow,
                   OUTPUT iPropID, OUTPUT cReason).

FIND ae_Proposal WHERE ae_Proposal.ProposalID = iPropID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN
    dFinalPrice = ae_Proposal.ProposedValue.
ELSE
    dFinalPrice = dListPrice..

RUN fp_comp_perk.p (INPUT iCustNum, INPUT iBookingNum,
                    INPUT dListPrice, INPUT dListPrice,
                    INPUT bLastSeat, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).

dBlocked = 0.
IF cFairness = 'HOLD' OR cFairness = 'EXPLOIT' THEN DO:
    FIND fp_Segment WHERE fp_Segment.SegName = cSegment NO-LOCK NO-ERROR.
    IF AVAILABLE fp_Segment THEN DO:
        RUN fp_floor.p (INPUT dListPrice, INPUT dMarginalCost, INPUT fp_Segment.FloorPct,
                        INPUT dOccupancy, INPUT dHoursLeft, INPUT dWindow,
                        OUTPUT dFloorForBlock).
        dWouldBe = MAXIMUM(dListPrice * (1 - fp_Segment.DiscountPct / 100), dFloorForBlock).
        dBlocked = MAXIMUM(0, ROUND(dFinalPrice - dWouldBe, 2)).
    END.
END.

cReason = cReason + ' | [COMP] R' + TRIM(STRING(dComp, '>>>,>>9.99'))
                  + ' | [PERK] ' + cPerk.
