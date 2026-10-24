DEFINE INPUT  PARAMETER iWarrantID AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER cReceipt   AS CHARACTER NO-UNDO.

DEFINE VARIABLE cBase AS CHARACTER NO-UNDO.
DEFINE VARIABLE cProp AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAsset AS CHARACTER NO-UNDO.

FIND ae_Warrant WHERE ae_Warrant.WarrantID = iWarrantID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Warrant THEN DO:
    cReceipt = 'Receipt not found.'.
    RETURN.
END.

FIND ae_Proposal WHERE ae_Proposal.ProposalID = ae_Warrant.ProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN DO:
    cBase = STRING(ae_Proposal.BaseValue, 'R>>>,>>9.99').
    cProp = STRING(ae_Proposal.ProposedValue, 'R>>>,>>9.99').
    
    FIND ae_Asset WHERE ae_Asset.AssetID = ae_Proposal.AssetID NO-LOCK NO-ERROR.
    IF AVAILABLE ae_Asset THEN cAsset = ae_Asset.AssetName.
    ELSE cAsset = 'General Asset'.
END.
ELSE DO:
    cBase = 'N/A'.
    cProp = 'N/A'.
    cAsset = 'Unknown'.
END.

cReceipt = 'Asset: ' + cAsset + ' | Base: ' + cBase + ' | Proposed: ' + cProp + ' | Rule: ' + ae_Warrant.Clauses + ' | Decision: ' + ae_Warrant.Ruling + ' | Warrant: ' + STRING(ae_Warrant.WarrantID).
