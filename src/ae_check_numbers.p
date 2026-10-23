DEFINE INPUT  PARAMETER cText     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER dAllowed1 AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dAllowed2 AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER lPassed   AS LOGICAL   NO-UNDO.

DEFINE VARIABLE iLoop AS INTEGER NO-UNDO.
DEFINE VARIABLE cWord AS CHARACTER NO-UNDO.
DEFINE VARIABLE dVal  AS DECIMAL   NO-UNDO.

lPassed = TRUE.
cText = REPLACE(cText, ",", ""). 

DO iLoop = 1 TO NUM-ENTRIES(cText, " "):
    cWord = ENTRY(iLoop, cText, " ").
    
    cWord = LEFT-TRIM(cWord, "R").
    cWord = RIGHT-TRIM(cWord, ".%").
    
    dVal = DECIMAL(cWord) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
        IF dVal <> dAllowed1 AND dVal <> dAllowed2 THEN DO:
            lPassed = FALSE.
            LEAVE.
        END.
    END.
END.
