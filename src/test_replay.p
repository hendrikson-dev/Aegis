DEFINE VARIABLE lMatch AS LOGICAL NO-UNDO.
DEFINE VARIABLE cOld   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNew   AS CHARACTER NO-UNDO.

RUN ae_replay.p (INPUT 14, OUTPUT lMatch, OUTPUT cOld, OUTPUT cNew).

IF lMatch THEN DO:
    MESSAGE 'REPLAY SUCCESS!' SKIP
            'Original Ruling: ' + cOld SKIP
            'Replayed Ruling: ' + cNew
        VIEW-AS ALERT-BOX INFO TITLE "Determinism Proven".
END.
ELSE DO:
    MESSAGE 'REPLAY FAILED!' SKIP
            'Original: ' + cOld SKIP
            'Replayed: ' + cNew
        VIEW-AS ALERT-BOX ERROR.
END.
