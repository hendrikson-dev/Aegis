DEFINE VARIABLE iProp AS INTEGER   NO-UNDO.
DEFINE VARIABLE oWarr AS INTEGER   NO-UNDO.
DEFINE VARIABLE cRul  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls  AS CHARACTER NO-UNDO.

MESSAGE 'Starting Regime Declaration Tests...' VIEW-AS ALERT-BOX.

RUN ae_declare.p (INPUT 'Surge', INPUT 'OwnerAdmin', INPUT 'Competitor closed', OUTPUT oWarr).
MESSAGE 'Owner declared Surge. Warrant ID: ' + STRING(oWarr) VIEW-AS ALERT-BOX INFO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 700
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Surge', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Under Surge: ' + cRul + ' | ' + cWhy VIEW-AS ALERT-BOX.

RUN ae_declare.p (INPUT 'Normal', INPUT 'OwnerAdmin', INPUT 'Back to normal', OUTPUT oWarr).
MESSAGE 'Owner declared Normal.' VIEW-AS ALERT-BOX INFO.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Under Normal: ' + cRul + ' | ' + cWhy VIEW-AS ALERT-BOX.
