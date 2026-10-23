DEFINE VARIABLE iProp AS INTEGER   NO-UNDO.
DEFINE VARIABLE cRul  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls  AS CHARACTER NO-UNDO.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 540
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Test 1 (Normal Rise): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 700
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Test 2 (Over Cap): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 280
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Test 3 (Below Floor): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 700
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Surge', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Test 4 (Surge): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 0
       ae_Proposal.ProposedValue = 500
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
MESSAGE 'Test 5 (Bad Base): ' + cRul + ' | ' + cCls VIEW-AS ALERT-BOX.
