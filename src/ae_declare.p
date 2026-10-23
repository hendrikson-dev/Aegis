DEFINE INPUT  PARAMETER cRegime   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cOwner    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER cReason   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER oWarrantID AS INTEGER   NO-UNDO.

DEFINE VARIABLE iWarrantID AS INTEGER NO-UNDO.

IF cRegime <> 'Normal' AND cRegime <> 'Surge' THEN DO:
    MESSAGE 'Error: Regime must be Normal or Surge.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

IF cOwner = '' OR cOwner = ? OR cReason = '' OR cReason = ? THEN DO:
    MESSAGE 'Error: Owner and Reason cannot be empty.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

DO TRANSACTION ON ERROR UNDO, LEAVE:
    CREATE ae_Warrant.
    ASSIGN ae_Warrant.WarrantID      = NEXT-VALUE(ae_WarrantSeq)
           ae_Warrant.ProposalID     = 0
           ae_Warrant.CharterVersion = 1
           ae_Warrant.Regime         = cRegime
           ae_Warrant.Clauses        = 'TR-1'
           ae_Warrant.Ruling         = 'Admit'
           ae_Warrant.ReasonCode     = cReason
           ae_Warrant.Authorizer     = cOwner
           ae_Warrant.SealedAt       = NOW.
           
    iWarrantID = ae_Warrant.WarrantID.

    CREATE ae_Regime.
    ASSIGN ae_Regime.RegimeID    = NEXT-VALUE(ae_RegimeSeq)
           ae_Regime.Regime      = cRegime
           ae_Regime.DeclaredBy  = cOwner
           ae_Regime.Reason      = cReason
           ae_Regime.DeclaredAt  = NOW
           ae_Regime.WarrantID   = iWarrantID.
END.

oWarrantID = iWarrantID.
