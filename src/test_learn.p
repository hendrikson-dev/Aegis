DEFINE VARIABLE i AS INTEGER NO-UNDO.

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

RUN ae_analytics.p.
