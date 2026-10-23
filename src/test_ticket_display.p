DEFINE VARIABLE iLookup     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSegment    AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScore      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cFairness   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dFinalPrice AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cReason     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dComp       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cPerk       AS CHARACTER NO-UNDO.



iLookup = 1.
RUN fp_classify.p (INPUT iLookup, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iLookup, OUTPUT cFairness).
RUN fp_price.p (INPUT iLookup, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT dFinalPrice, OUTPUT cReason).
RUN fp_comp_perk.p (INPUT iLookup, INPUT 1, INPUT 420.00, INPUT 420.00, INPUT NO, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iLookup cSegment dScore cFairness dFinalPrice dComp cPerk.

iLookup = 2.
RUN fp_classify.p (INPUT iLookup, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iLookup, OUTPUT cFairness).
RUN fp_price.p (INPUT iLookup, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT dFinalPrice, OUTPUT cReason).
RUN fp_comp_perk.p (INPUT iLookup, INPUT 4, INPUT 420.00, INPUT 420.00, INPUT NO, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iLookup cSegment dScore cFairness dFinalPrice dComp cPerk.

iLookup = 3.
RUN fp_classify.p (INPUT iLookup, OUTPUT cSegment, OUTPUT dScore).
RUN fp_fairness.p (INPUT iLookup, OUTPUT cFairness).
RUN fp_price.p (INPUT iLookup, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72,
                OUTPUT dFinalPrice, OUTPUT cReason).
RUN fp_comp_perk.p (INPUT iLookup, INPUT 0, INPUT 420.00, INPUT 420.00, INPUT YES, INPUT cFairness,
                    OUTPUT dComp, OUTPUT cPerk).
DISPLAY iLookup cSegment dScore cFairness dFinalPrice dComp cPerk.
