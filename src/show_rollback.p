DEFINE VARIABLE iBefore AS INTEGER NO-UNDO.
DEFINE VARIABLE iAfter  AS INTEGER NO-UNDO.
DEFINE VARIABLE iProp   AS INTEGER NO-UNDO.
DEFINE VARIABLE oWarr   AS INTEGER NO-UNDO.

FOR EACH ae_Warrant NO-LOCK: iBefore = iBefore + 1. END.
MESSAGE "Warrants in Ledger BEFORE failure: " + STRING(iBefore) VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 540
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

MESSAGE "Attempting to seal with an invalid rule..." VIEW-AS ALERT-BOX.
RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT 'InvalidRuling', INPUT 'Test', INPUT 'PR-1', OUTPUT oWarr) NO-ERROR.

FOR EACH ae_Warrant NO-LOCK: iAfter = iAfter + 1. END.
MESSAGE "Warrants in Ledger AFTER failure: " + STRING(iAfter) VIEW-AS ALERT-BOX.
