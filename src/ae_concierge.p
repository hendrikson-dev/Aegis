DEFINE INPUT  PARAMETER iWarrantID AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER cReceipt   AS CHARACTER NO-UNDO.

DEFINE VARIABLE cBase AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProp AS CHARACTER NO-UNDO.

FIND ae_Warrant WHERE ae_Warrant.WarrantID = iWarrantID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Warrant THEN DO:
    cReceipt = 'Receipt not found.'.
    RETURN.
END.

FIND ae_Proposal WHERE ae_Proposal.ProposalID = ae_Warrant.ProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN DO:
    cBase = STRING(ae_Proposal.BaseValue, 'R>>>,>>9.99').
    cProp = STRING(ae_Proposal.ProposedValue, 'R>>>,>>9.99').
END.
ELSE DO:
    cBase = 'N/A'.
    cProp = 'N/A'.
END.

cReceipt = 'Base Price: ' + cBase + ' | Proposed Price: ' + cProp + ' | Rule Applied: ' + ae_Warrant.Clauses + ' | Decision: ' + ae_Warrant.Ruling + ' | Warrant ID: ' + STRING(ae_Warrant.WarrantID).
