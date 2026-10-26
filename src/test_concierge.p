DEFINE VARIABLE cRec  AS CHARACTER NO-UNDO.
DEFINE VARIABLE oWarr AS INTEGER NO-UNDO.

FIND LAST ae_Warrant NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Warrant THEN DO:
    MESSAGE 'No Warrants exist in the ledger yet.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

oWarr = ae_Warrant.WarrantID.

RUN ae_concierge.p (INPUT oWarr, OUTPUT cRec).
MESSAGE cRec VIEW-AS ALERT-BOX INFO TITLE "Customer Receipt (Warrant " + STRING(oWarr) + ")".
