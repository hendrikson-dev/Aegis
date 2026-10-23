DEFINE INPUT  PARAMETER iCustNum   AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER cFairness  AS CHARACTER NO-UNDO.
DEFINE VARIABLE iMaxRisk AS INTEGER NO-UNDO.

cFairness = 'RELEASE'.

FOR EACH fp_Behaviour WHERE fp_Behaviour.CustNum = iCustNum
                      AND fp_Behaviour.ActiveStatus = 'Active' NO-LOCK:
    
    IF fp_Behaviour.RiskLevel > iMaxRisk THEN 
        iMaxRisk = fp_Behaviour.RiskLevel.
END.

IF iMaxRisk >= 3 THEN
    cFairness = 'EXPLOIT'.
ELSE IF iMaxRisk = 2 THEN
    cFairness = 'HOLD'.
