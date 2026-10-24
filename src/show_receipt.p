DEFINE VARIABLE iProp AS INTEGER   NO-UNDO.
DEFINE VARIABLE oWarr AS INTEGER   NO-UNDO.
DEFINE VARIABLE cRul  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRec  AS CHARACTER NO-UNDO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 540
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).

RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT cRul, INPUT cWhy, INPUT cCls, OUTPUT oWarr).

RUN ae_concierge.p (INPUT oWarr, OUTPUT cRec).

MESSAGE cRec VIEW-AS ALERT-BOX INFO TITLE "Customer Receipt".
