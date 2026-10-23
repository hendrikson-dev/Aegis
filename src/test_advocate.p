DEFINE VARIABLE iProp AS INTEGER NO-UNDO.
DEFINE VARIABLE cTxt  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSrc  AS CHARACTER NO-UNDO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 400.
iProp = ae_Proposal.ProposalID.

RUN ae_advocate.p (INPUT iProp, OUTPUT cTxt, OUTPUT cSrc).
MESSAGE 'Test 8a (Good AI): ' + cSrc + ' | ' + cTxt VIEW-AS ALERT-BOX.
