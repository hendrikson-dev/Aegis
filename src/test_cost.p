DEFINE VARIABLE iLookup     AS INTEGER   NO-UNDO.
DEFINE VARIABLE dPrice      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cWhy        AS CHARACTER NO-UNDO.
DEFINE VARIABLE oProposalID AS INTEGER   NO-UNDO.

iLookup = 1.
RUN fp_price.p (INPUT iLookup, INPUT 0, INPUT 420.00, INPUT 999.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT oProposalID, OUTPUT cWhy).

FIND ae_Proposal WHERE ae_Proposal.ProposalID = oProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN
    dPrice = ae_Proposal.ProposedValue.
ELSE
    dPrice = 420.00.

DISPLAY iLookup dPrice cWhy.
