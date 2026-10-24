DEFINE VARIABLE cRul AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls AS CHARACTER NO-UNDO.
DEFINE VARIABLE iProp AS INTEGER NO-UNDO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine = 'Strategy'
       ae_Proposal.AssetID = 1 
       ae_Proposal.BaseValue = 500
       ae_Proposal.ProposedValue = 700 
       ae_Proposal.FloorValue = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE '07:00 AM Bus (Normal): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.

RUN ae_steward.p (INPUT iProp, INPUT 'Surge', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE '07:00 AM Bus (Surge): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.
