DEFINE VARIABLE cList AS CHARACTER NO-UNDO
    INITIAL "fp_seed.p,seed_profile.p,ae_charter_seed.p,seed_day4.p,reset_sim.p,gen_data.p,seed_demo.p,check_demo.p".
DEFINE VARIABLE i AS INTEGER NO-UNDO.

DO i = 1 TO NUM-ENTRIES(cList):
    IF SEARCH(ENTRY(i, cList)) = ? THEN DO:
        MESSAGE "Missing program: " + ENTRY(i, cList)
            VIEW-AS ALERT-BOX ERROR.
        RETURN.
    END.
END.

DO i = 1 TO NUM-ENTRIES(cList):
    RUN VALUE(ENTRY(i, cList)).
END.

MESSAGE "Rebuild finished. Run tests.bat (expect 7 PASS), then count.bat."
    VIEW-AS ALERT-BOX INFORMATION.
