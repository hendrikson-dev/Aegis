DEFINE VARIABLE cBase   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cAction AS CHARACTER NO-UNDO.

cBase   = OS-GETENV("FAIRPLAY_DIR").
cAction = OS-GETENV("FAIRPLAY_ACTION").

IF cBase = "" OR cBase = ? THEN DO:
        MESSAGE "Start Aegis with demo.bat, tests.bat, count.bat or rebuild.bat."
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.

IF cAction = "" OR cAction = ? THEN cAction = "demo".

PROPATH = PROPATH + "," + cBase + "\src" + "," + cBase + "\seed" + "," + OS-GETENV("DLC") + "\gui\netlib\OpenEdge.Net.pl".

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
    WHEN "count"   THEN RUN test_count.p.
    OTHERWISE
        MESSAGE "Unknown action: " + cAction
            VIEW-AS ALERT-BOX ERROR.
END CASE.
