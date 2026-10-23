DEFINE VARIABLE iOverrides AS INTEGER NO-UNDO.
DEFINE VARIABLE cMessage   AS CHARACTER NO-UNDO.

iOverrides = 0.

FOR EACH ae_Warrant WHERE ae_Warrant.Ruling = 'Override' 
                      AND ae_Warrant.ReasonCode = 'Strategic Override'
                      AND ae_Warrant.Clauses BEGINS 'PR-' 
                      AND ae_Warrant.SealedAt >= NOW - 30 NO-LOCK:
    iOverrides = iOverrides + 1.
END.

IF iOverrides >= 3 THEN DO:
    cMessage = "INSIGHT DETECTED: " + STRING(iOverrides) + " strategic overrides in the last 30 days. "
             + "The current charter cap may be too restrictive. "
             + "Recommendation: Owner reviews Charter limits.".
    MESSAGE cMessage VIEW-AS ALERT-BOX INFO TITLE "Aegis Insight Report".
END.
ELSE DO:
    MESSAGE "No significant override patterns detected." 
        VIEW-AS ALERT-BOX INFO TITLE "Aegis Insight Report".
END.
