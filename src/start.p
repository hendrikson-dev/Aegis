MESSAGE "start.p is running" VIEW-AS ALERT-BOX.

DEFINE VARIABLE cBase   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAction AS CHARACTER NO-UNDO.

cBase   = OS-GETENV("FAIRPLAY_DIR").
cAction = OS-GETENV("FAIRPLAY_ACTION").

IF cBase = "" OR cBase = ? THEN DO:
    MESSAGE "Start FairPlay with demo.bat, tests.bat or rebuild.bat."
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

IF cAction = "" OR cAction = ? THEN cAction = "demo".

PROPATH = PROPATH + "," + cBase + "\src" + "," + cBase + "\seed".

IF SEARCH("fp_classify.p") = ? THEN DO:
    MESSAGE "Cannot find fp_classify.p." SKIP
            "Project folder: " + cBase SKIP
            "PROPATH: " + PROPATH
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

CASE cAction:
    WHEN "demo"    THEN RUN run_sim.p.
    WHEN "tests"   THEN DO:
        RUN test_all.p.
        RUN test_break.p.
    END.
    WHEN "rebuild" THEN RUN rebuild_seed.p.
    OTHERWISE
        MESSAGE "Unknown action: " + cAction
            VIEW-AS ALERT-BOX ERROR.
END CASE.
