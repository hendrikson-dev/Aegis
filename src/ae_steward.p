DEFINE INPUT  PARAMETER iProposalID AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER cRegime     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cRuling     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cReason     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cClause     AS CHARACTER NO-UNDO.

DEFINE VARIABLE dMaxRise   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cPriceRule AS CHARACTER NO-UNDO.

FIND ae_Proposal WHERE ae_Proposal.ProposalID = iProposalID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Proposal THEN DO:
    cRuling = 'Deny'.
    cReason = 'Proposal not found'.
    cClause = 'None'.
    RETURN.
END.

FIND FIRST ae_Charter WHERE ae_Charter.ClauseID = 'PR-3' 
                        AND ae_Charter.Active = TRUE NO-LOCK NO-ERROR.
IF AVAILABLE ae_Charter THEN DO:
    IF ae_Proposal.ProposedValue < ae_Proposal.FloorValue THEN DO:
        cRuling = 'Deny'.
        cReason = 'Proposed price is below the floor'.
        cClause = 'PR-3'.
        RETURN.
    END.
END.

IF cRegime = 'Surge' THEN 
    cPriceRule = 'PR-2'.
ELSE 
    cPriceRule = 'PR-1'.

FIND FIRST ae_Charter WHERE ae_Charter.ClauseID = cPriceRule
                        AND ae_Charter.Active = TRUE NO-LOCK NO-ERROR.
                        
IF NOT AVAILABLE ae_Charter THEN DO:
    cRuling = 'Deny'.
    cReason = 'No active price rule found for regime ' + cRegime.
    cClause = 'None'.
    RETURN.
END.

dMaxRise = ae_Proposal.BaseValue * (1 + ae_Charter.LimitValue).

IF ae_Proposal.ProposedValue > dMaxRise THEN DO:
    cRuling = 'Deny'.
    cReason = 'Price rise exceeds the cap for ' + cRegime + ' regime'.
    cClause = ae_Charter.ClauseID.
    RETURN.
END.
ELSE DO:
    cRuling = 'Admit'.
    cReason = 'Proposal is within Charter limits'.
    cClause = ae_Charter.ClauseID.
END.
