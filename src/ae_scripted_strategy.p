DEFINE INPUT  PARAMETER iCustNum   AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER dBasePrice AS DECIMAL NO-UNDO.
DEFINE INPUT  PARAMETER dRisePct   AS DECIMAL NO-UNDO.
DEFINE OUTPUT PARAMETER iProposalID AS INTEGER NO-UNDO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.Subject       = STRING(iCustNum)
       ae_Proposal.Kind          = 'Price'
       ae_Proposal.BaseValue     = dBasePrice
       ae_Proposal.ProposedValue = dBasePrice * (1 + (dRisePct / 100))
       ae_Proposal.FloorValue    = dBasePrice * 0.6 
       ae_Proposal.TextSource    = 'MOCK'
       ae_Proposal.CreatedAt     = NOW.

iProposalID = ae_Proposal.ProposalID.
