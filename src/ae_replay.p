DEFINE INPUT  PARAMETER iWarrantID   AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER lMatch       AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER cOldRuling   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cNewRuling   AS CHARACTER NO-UNDO.

DEFINE VARIABLE iProposalID AS INTEGER   NO-UNDO.
DEFINE VARIABLE cRegime     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRsn        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls        AS CHARACTER NO-UNDO.

FIND ae_Warrant WHERE ae_Warrant.WarrantID = iWarrantID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Warrant THEN DO:
    lMatch = FALSE.
    RETURN.
END.

iProposalID = ae_Warrant.ProposalID.
cRegime     = ae_Warrant.Regime.
cOldRuling  = ae_Warrant.Ruling.

RUN ae_steward.p (INPUT iProposalID, INPUT cRegime, OUTPUT cNewRuling, OUTPUT cRsn, OUTPUT cCls).

IF cNewRuling = cOldRuling THEN 
    lMatch = TRUE.
ELSE 
    lMatch = FALSE.
