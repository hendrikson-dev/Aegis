DEFINE VARIABLE iCust       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSegment    AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScore      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cFairness   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFinalPrice AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cReason     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dComp       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cPerk       AS CHARACTER NO-UNDO.
DEFINE VARIABLE oProposalID AS INTEGER   NO-UNDO.

iCust = 1.
RUN fp_classify.p (INPUT iCust, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iCust, OUTPUT cFairness).

RUN fp_price.p (INPUT iCust, INPUT 0, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT oProposalID, OUTPUT cReason).

FIND ae_Proposal WHERE ae_Proposal.ProposalID = oProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN dFinalPrice = ae_Proposal.ProposedValue.
ELSE dFinalPrice = 420.00.

RUN fp_comp_perk.p (INPUT iCust, INPUT 1, INPUT 420.00, INPUT 420.00, INPUT NO, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iCust LABEL "Cust" cSegment dScore cFairness dFinalPrice dComp cPerk.

iCust = 2.
RUN fp_classify.p (INPUT iCust, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iCust, OUTPUT cFairness).

RUN fp_price.p (INPUT iCust, INPUT 0, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT oProposalID, OUTPUT cReason).

FIND ae_Proposal WHERE ae_Proposal.ProposalID = oProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN dFinalPrice = ae_Proposal.ProposedValue.
ELSE dFinalPrice = 420.00.

RUN fp_comp_perk.p (INPUT iCust, INPUT 4, INPUT 420.00, INPUT 420.00, INPUT NO, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iCust LABEL "Cust" cSegment dScore cFairness dFinalPrice dComp cPerk.

iCust = 3.
RUN fp_classify.p (INPUT iCust, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iCust, OUTPUT cFairness).

RUN fp_price.p (INPUT iCust, INPUT 0, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT oProposalID, OUTPUT cReason).

FIND ae_Proposal WHERE ae_Proposal.ProposalID = oProposalID NO-LOCK NO-ERROR.
IF AVAILABLE ae_Proposal THEN dFinalPrice = ae_Proposal.ProposedValue.
ELSE dFinalPrice = 420.00.

RUN fp_comp_perk.p (INPUT iCust, INPUT 0, INPUT 420.00, INPUT 420.00, INPUT YES, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iCust LABEL "Cust" cSegment dScore cFairness dFinalPrice dComp cPerk.
