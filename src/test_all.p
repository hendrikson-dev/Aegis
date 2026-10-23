DEFINE VARIABLE cSeg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScr   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cFair  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dPrice AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cWhy   AS CHARACTER NO-UNDO.
DEFINE VARIABLE dComp  AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cPerk  AS CHARACTER NO-UNDO.

DEFINE VARIABLE cResult1 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult2 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult3 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult4 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult5 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult6 AS CHARACTER NO-UNDO.
DEFINE VARIABLE cResult7 AS CHARACTER NO-UNDO.
DEFINE VARIABLE dBal     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dApply   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dCash    AS DECIMAL   NO-UNDO.



FOR EACH fp_Behaviour WHERE fp_Behaviour.CustNum = 3 EXCLUSIVE-LOCK:
    DELETE fp_Behaviour.
END.

RUN fp_classify.p (INPUT 1, OUTPUT cSeg, OUTPUT dScr).
cResult1 = "1 Customer 1 is Regular, score 45 : " + (IF cSeg = 'Regular' AND dScr = 45 THEN 'PASS' ELSE 'FAIL').

RUN fp_fairness.p (INPUT 2, OUTPUT cFair).
cResult2 = "2 Customer 2 gets a HOLD : " + (IF cFair = 'HOLD' THEN 'PASS' ELSE 'FAIL').

RUN fp_price.p (INPUT 1, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72, OUTPUT dPrice, OUTPUT cWhy).
cResult3 = "3 Customer 1 pays R399 : " + (IF dPrice = 399.00 THEN 'PASS' ELSE 'FAIL').

RUN fp_price.p (INPUT 2, INPUT 420.00, INPUT 300.00, INPUT 50, INPUT 999, INPUT 72, OUTPUT dPrice, OUTPUT cWhy).
cResult4 = "4 Customer 2 pays R420 (held) : " + (IF dPrice = 420.00 THEN 'PASS' ELSE 'FAIL').

RUN fp_comp_perk.p (INPUT 1, INPUT 1, INPUT 420.00, INPUT 420.00, INPUT NO, INPUT 'RELEASE',
                    OUTPUT dComp, OUTPUT cPerk).
cResult5 = "5 Compensation is R80 : " + (IF dComp = 80.00 THEN 'PASS' ELSE 'FAIL').

RUN fp_comp_perk.p (INPUT 3, INPUT 0, INPUT 420.00, INPUT 420.00, INPUT YES, INPUT 'RELEASE',
                    OUTPUT dComp, OUTPUT cPerk).
cResult6 = "6 Customer 3 gets a Voucher : " + (IF cPerk = 'Voucher' THEN 'PASS' ELSE 'FAIL').

RUN fp_comp_perk.p (INPUT 1, INPUT 1, INPUT 500.00, INPUT 420.00, INPUT NO, INPUT 'RELEASE',
                    OUTPUT dComp, OUTPUT cPerk).
cResult7 = "7 No comp when value unchanged : " + (IF dComp = 0.00 THEN 'PASS' ELSE 'FAIL').

DISPLAY 
    cResult1 FORMAT "x(60)" 
    cResult2 FORMAT "x(60)" 
    cResult3 FORMAT "x(60)" 
    cResult4 FORMAT "x(60)" 
    cResult5 FORMAT "x(60)" 
    cResult6 FORMAT "x(60)"
    cResult7 FORMAT "x(60)"
    WITH FRAME test_frame 1 COLUMN WIDTH 70 NO-BOX NO-LABELS.
