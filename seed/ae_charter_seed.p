DEFINE VARIABLE iCount AS INTEGER NO-UNDO.

DO TRANSACTION ON ERROR UNDO, LEAVE:
    FOR EACH ae_Charter WHERE ae_Charter.Version = 1 EXCLUSIVE-LOCK:
        DELETE ae_Charter.
    END.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'PR-1'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'Strategy'
           ae_Charter.Regime        = 'Normal'
           ae_Charter.RuleText      = 'Maximum price rise per change'
           ae_Charter.LimitValue    = 0.10
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'PR-2'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'Strategy'
           ae_Charter.Regime        = 'Surge'
           ae_Charter.RuleText      = 'Maximum price rise per change'
           ae_Charter.LimitValue    = 0.40
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'PR-3'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'Strategy'
           ae_Charter.Regime        = 'All'
           ae_Charter.RuleText      = 'Price may not go below the floor'
           ae_Charter.LimitValue    = 0
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'LI-1'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'Provision'
           ae_Charter.Regime        = 'All'
           ae_Charter.RuleText      = 'Every price drop gets a recorded decision'
           ae_Charter.LimitValue    = 1
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'LI-2'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'Provision'
           ae_Charter.Regime        = 'All'
           ae_Charter.RuleText      = 'Liability may not exceed the price difference'
           ae_Charter.LimitValue    = 1.00
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    CREATE ae_Charter.
    ASSIGN ae_Charter.ClauseID      = 'TR-1'
           ae_Charter.Version       = 1
           ae_Charter.EngineScope   = 'All'
           ae_Charter.Regime        = 'All'
           ae_Charter.RuleText      = 'Every Warrant names the clause applied'
           ae_Charter.LimitValue    = 1
           ae_Charter.Active        = TRUE
           ae_Charter.EffectiveFrom = NOW.

    IF NOT CAN-FIND(FIRST ae_Regime) THEN DO:
        CREATE ae_Regime.
        ASSIGN ae_Regime.RegimeID    = NEXT-VALUE(ae_RegimeSeq)
               ae_Regime.Regime      = 'Normal'
               ae_Regime.DeclaredBy  = 'system'
               ae_Regime.Reason      = 'starting regime'
               ae_Regime.DeclaredAt  = NOW
               ae_Regime.WarrantID   = 0.
    END.
END.

MESSAGE 'Charter v1 loaded' VIEW-AS ALERT-BOX.
