DEFINE INPUT  PARAMETER iProposalID AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER cRegime     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cRuling     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cReason     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cClause     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER oWarrantID  AS INTEGER   NO-UNDO.

DEFINE VARIABLE iWarrantID AS INTEGER NO-UNDO.

IF LOOKUP(cRuling, 'Admit,Deny,Override') = 0 THEN
    RETURN ERROR 'Invalid ruling: ' + cRuling.
IF LOOKUP(cRegime, 'Normal,Surge') = 0 THEN
    RETURN ERROR 'Invalid regime: ' + cRegime.

DO TRANSACTION ON ERROR UNDO, LEAVE:
    
    CREATE ae_Warrant.
    ASSIGN ae_Warrant.WarrantID      = NEXT-VALUE(ae_WarrantSeq)
           ae_Warrant.ProposalID     = iProposalID
           ae_Warrant.CharterVersion = 1
           ae_Warrant.Regime         = cRegime
           ae_Warrant.Clauses        = cClause
           ae_Warrant.Ruling         = cRuling
           ae_Warrant.ReasonCode     = cReason
           ae_Warrant.Authorizer     = 'Steward'
           ae_Warrant.SealedAt       = NOW.
           
    iWarrantID = ae_Warrant.WarrantID.

    IF cRuling = 'Deny' THEN DO:
        CREATE ae_Exception.
        ASSIGN ae_Exception.ExceptionID = NEXT-VALUE(ae_ExceptionSeq)
               ae_Exception.WarrantID   = iWarrantID
               ae_Exception.ExcState    = 'Open'
               ae_Exception.ReasonCode  = 'Denied by Steward'.
    END.

END.

oWarrantID = iWarrantID.
