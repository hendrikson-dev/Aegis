DEFINE VARIABLE i AS INTEGER NO-UNDO.
DEFINE VARIABLE iOverrides AS INTEGER NO-UNDO.

MESSAGE 'Simulating 3 manager overrides...' VIEW-AS ALERT-BOX.

DO i = 1 TO 3:
    CREATE ae_Warrant.
    ASSIGN ae_Warrant.WarrantID      = NEXT-VALUE(ae_WarrantSeq)
           ae_Warrant.ProposalID     = 1 /* Mock ID */
           ae_Warrant.CharterVersion = 1
           ae_Warrant.Regime         = 'Normal'
           ae_Warrant.Clauses        = 'PR-1'
           ae_Warrant.Ruling         = 'Override'
           ae_Warrant.ReasonCode     = 'Strategic Override'
           ae_Warrant.Authorizer     = 'ManagerX'
           ae_Warrant.SealedAt       = NOW.
END.

FOR EACH ae_Warrant WHERE ae_Warrant.Ruling = 'Override' 
                      AND ae_Warrant.ReasonCode = 'Strategic Override'
                      NO-LOCK:
    iOverrides = iOverrides + 1.
END.

IF iOverrides >= 3 THEN DO:
    MESSAGE 'INSIGHT DETECTED BY OMBUDSMAN AI:' SKIP(1)
            'System has recorded ' + STRING(iOverrides) + ' strategic overrides.' SKIP
            'Recommendation: The current Charter cap is too restrictive.' SKIP
            'Action: Auto-adopt dynamic pricing for this route.'
        VIEW-AS ALERT-BOX INFO TITLE "Precog Learning Engine".
END.
ELSE DO:
    MESSAGE 'Not enough overrides to detect a pattern.' VIEW-AS ALERT-BOX INFO.
END.

MESSAGE 'NOTE: These test rows are now in your Ledger.' SKIP
        'You MUST delete the db folder and run rebuild.bat before the demo.'
    VIEW-AS ALERT-BOX WARNING.
