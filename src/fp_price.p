/* fp_price.p */
DEFINE INPUT  PARAMETER iCustNum       AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER iAssetID       AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER dBasePrice     AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER dMarginalCost  AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER dOccupancy     AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER dHoursLeft     AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER dWindow        AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER oProposalID    AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER cReason        AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cSegment     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dScore       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dDiscountPct AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFloorPct    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dDiscounted  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dFloor       AS DECIMAL    NO-UNDO.
DEFINE VARIABLE cFloorState  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFairness    AS CHARACTER  NO-UNDO.

DEFINE VARIABLE dFinalPrice  AS DECIMAL    NO-UNDO.

dFinalPrice = dBasePrice.

RUN fp_classify.p (INPUT iCustNum, OUTPUT cSegment, OUTPUT dScore).

FIND ae_Asset WHERE ae_Asset.AssetID = iAssetID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Asset THEN 
    dBasePrice = ae_Asset.BasePrice.

FIND fp_Segment WHERE fp_Segment.SegName = cSegment NO-LOCK NO-ERROR.
IF NOT AVAILABLE fp_Segment THEN DO:
    cReason = '[SEGMENT] ' + cSegment + ' | NO segment rules found, base price used'.
    
    CREATE ae_Proposal.
    ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
           ae_Proposal.AssetID       = iAssetID
           ae_Proposal.Engine        = 'Strategy'
           ae_Proposal.Subject       = STRING(iCustNum)
           ae_Proposal.Kind          = 'Price'
           ae_Proposal.BaseValue     = dBasePrice
           ae_Proposal.ProposedValue = dBasePrice
           ae_Proposal.FloorValue    = dMarginalCost
           ae_Proposal.TextSource    = 'MOCK'
           ae_Proposal.CreatedAt     = NOW.
           
    oProposalID = ae_Proposal.ProposalID.
    RETURN.
END.

dDiscountPct = fp_Segment.DiscountPct.
dFloorPct    = fp_Segment.FloorPct.

RUN fp_fairness.p (INPUT iCustNum, OUTPUT cFairness).
IF cFairness = 'HOLD' OR cFairness = 'EXPLOIT' THEN
    dDiscountPct = 0.

dDiscounted = dBasePrice * (1 - dDiscountPct / 100).

RUN fp_floor.p (INPUT dBasePrice, INPUT dMarginalCost, INPUT dFloorPct,
                INPUT dOccupancy, INPUT dHoursLeft, INPUT dWindow, OUTPUT dFloor).

IF dDiscounted < dFloor THEN
    ASSIGN dFinalPrice = dFloor      cFloorState = 'held'.
ELSE
    ASSIGN dFinalPrice = dDiscounted cFloorState = 'ok'.

dFinalPrice = ROUND(dFinalPrice, 2).

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.Subject       = STRING(iCustNum)
       ae_Proposal.Kind          = 'Price'
       ae_Proposal.BaseValue     = dBasePrice
       ae_Proposal.ProposedValue = dFinalPrice
       ae_Proposal.FloorValue    = dFloor
       ae_Proposal.TextSource    = 'MOCK'
       ae_Proposal.CreatedAt     = NOW.

oProposalID = ae_Proposal.ProposalID.

cReason = '[SEGMENT] ' + cSegment
        + ' | [DISCOUNT] ' + TRIM(STRING(dDiscountPct, '>>9.99')) + '%'
        + ' | [FLOOR] R' + TRIM(STRING(dFloor, '>>>,>>>9.99')) + ' ' + cFloorState
        + ' | [FAIRNESS] ' + cFairness.
