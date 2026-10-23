DEFINE VARIABLE cProfile AS CHARACTER NO-UNDO.
DEFINE VARIABLE dNewCost AS DECIMAL   NO-UNDO.

cProfile = 'Hotel'.
dNewCost = 1100.

FIND fp_Profile WHERE fp_Profile.ProfileName = cProfile EXCLUSIVE-LOCK NO-ERROR.

IF NOT AVAILABLE fp_Profile THEN DO:
    MESSAGE 'Profile ' + cProfile + ' not found.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

ASSIGN fp_Profile.MarginalCost = dNewCost.

MESSAGE 'Updated ' + cProfile + ' cost to R' + STRING(dNewCost)
    VIEW-AS ALERT-BOX INFORMATION.
