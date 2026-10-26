DEFINE VARIABLE lMatch AS LOGICAL NO-UNDO.
DEFINE VARIABLE cOld   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNew   AS CHARACTER NO-UNDO.
DEFINE VARIABLE oWarr  AS INTEGER NO-UNDO.

FIND LAST ae_Warrant NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Warrant THEN DO:
    MESSAGE 'No Warrants exist in the ledger yet.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

oWarr = ae_Warrant.WarrantID.

RUN ae_replay.p (INPUT oWarr, OUTPUT lMatch, OUTPUT cOld, OUTPUT cNew).

IF lMatch THEN DO:
    MESSAGE 'REPLAY SUCCESS!' SKIP
            'Original Ruling: ' + cOld SKIP
            'Replayed Ruling: ' + cNew SKIP
            'Warrant ID: ' + STRING(oWarr)
        VIEW-AS ALERT-BOX INFO TITLE "Determinism Proven".
END.
ELSE DO:
    MESSAGE 'REPLAY FAILED!' SKIP
            'Original: ' + cOld SKIP
            'Replayed: ' + cNew
        VIEW-AS ALERT-BOX ERROR.
END.
