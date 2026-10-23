DEFINE INPUT  PARAMETER iCustNum      AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER cBehaviorCode AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER iRiskLevel    AS INTEGER   NO-UNDO.

DEFINE VARIABLE bStart AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns1  AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns2  AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns3  AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns4  AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns5  AS LOGICAL NO-UNDO.
DEFINE VARIABLE bAns6  AS LOGICAL NO-UNDO.
DEFINE VARIABLE cAnswers AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNext AS INTEGER NO-UNDO INITIAL 1.

cBehaviorCode = 'NO_SIGNAL'.
iRiskLevel = 0.

FIND FIRST fp_Behaviour WHERE fp_Behaviour.CustNum = iCustNum NO-LOCK NO-ERROR.
IF AVAILABLE fp_Behaviour THEN DO:
    ASSIGN cBehaviorCode = fp_Behaviour.BehaviourCode
           iRiskLevel = fp_Behaviour.RiskLevel.
    RETURN.
END.

MESSAGE 'Welcome! Would you like to answer 6 quick questions to help us personalize your booking experience? (Click No to skip and book fast)'
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bStart.

IF bStart <> TRUE THEN DO:
    FOR EACH fp_Behaviour NO-LOCK:
        IF fp_Behaviour.BehaviourID >= iNext THEN 
            iNext = fp_Behaviour.BehaviourID + 1.
    END.
    
    CREATE fp_Behaviour.
    ASSIGN fp_Behaviour.BehaviourID   = iNext
           fp_Behaviour.CustNum       = iCustNum
           fp_Behaviour.ActiveStatus  = 'Active'
           fp_Behaviour.BookingBehaviour = 'FastTrack'
           fp_Behaviour.RiskLevel     = 0
           fp_Behaviour.BehaviourCode = 'NO_SIGNAL'
           fp_Behaviour.Description   = 'Customer skipped questionnaire'.
           
    ASSIGN cBehaviorCode = 'NO_SIGNAL' iRiskLevel = 0.
    RETURN.
END.

MESSAGE '1 of 6: Is this your first time booking with us?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns1.

IF bAns1 <> TRUE THEN DO:
    FOR EACH fp_Behaviour NO-LOCK:
        IF fp_Behaviour.BehaviourID >= iNext THEN 
            iNext = fp_Behaviour.BehaviourID + 1.
    END.
    
    CREATE fp_Behaviour.
    ASSIGN fp_Behaviour.BehaviourID   = iNext
           fp_Behaviour.CustNum       = iCustNum
           fp_Behaviour.ActiveStatus  = 'Active'
           fp_Behaviour.BookingBehaviour = 'Questionnaire'
           fp_Behaviour.RiskLevel     = 0
           fp_Behaviour.BehaviourCode = 'NO_SIGNAL'
           fp_Behaviour.Description   = 'Customer is not new, skipped remaining questions'.
           
    ASSIGN cBehaviorCode = 'NO_SIGNAL' iRiskLevel = 0.
    RETURN.
END.

MESSAGE '2 of 6: Did you look at this trip price before today?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns2.
MESSAGE '3 of 6: Did you decide that price was too high for your budget?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns3.
MESSAGE '4 of 6: Is your travel date fixed?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns4.
MESSAGE '5 of 6: Did you plan to wait for the price to drop?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns5.
MESSAGE '6 of 6: Do you travel with us regularly?' 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bAns6.

IF bAns5 AND NOT bAns3 THEN DO:
    IF bAns4 THEN 
        ASSIGN cBehaviorCode = 'PLANNED_TO_WAIT' iRiskLevel = 1.
    ELSE 
        ASSIGN cBehaviorCode = 'PLANNED_TO_WAIT' iRiskLevel = 2.
END.
ELSE IF bAns2 AND bAns3 THEN
    ASSIGN cBehaviorCode = 'VIEWED_THEN_LEFT' iRiskLevel = 0.

cAnswers = STRING(bAns1, 'Y/N') + STRING(bAns2, 'Y/N') + STRING(bAns3, 'Y/N')
         + STRING(bAns4, 'Y/N') + STRING(bAns5, 'Y/N') + STRING(bAns6, 'Y/N').

FOR EACH fp_Behaviour NO-LOCK:
    IF fp_Behaviour.BehaviourID >= iNext THEN 
        iNext = fp_Behaviour.BehaviourID + 1.
END.

CREATE fp_Behaviour.
ASSIGN fp_Behaviour.BehaviourID   = iNext
       fp_Behaviour.CustNum       = iCustNum
       fp_Behaviour.ActiveStatus  = 'Active'
       fp_Behaviour.BookingBehaviour = 'Questionnaire'
       fp_Behaviour.RiskLevel     = iRiskLevel
       fp_Behaviour.BehaviourCode = cBehaviorCode
       fp_Behaviour.Description   = 'Answers 1 to 6: ' + cAnswers.
