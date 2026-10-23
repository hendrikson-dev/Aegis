DEFINE INPUT  PARAMETER cScenario AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cResponse AS CHARACTER NO-UNDO.

CASE cScenario:
    WHEN 'good' THEN 
        cResponse = 'You were charged R500 and the new price is R400.'.
    WHEN 'bad' THEN 
        cResponse = 'You were charged R500 and the new price is R999.'.
    WHEN 'empty' THEN 
        cResponse = ''.
    WHEN 'slow' THEN DO:
        PAUSE 3 NO-MESSAGE.
        cResponse = 'You were charged R500 and the new price is R400.'.
    END.
    OTHERWISE 
        cResponse = 'Error'.
END CASE.
