DEFINE INPUT  PARAMETER iProposalID AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER cText       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cSource     AS CHARACTER NO-UNDO.

DEFINE VARIABLE cAiText  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lPassed  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dBase    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dProp    AS DECIMAL   NO-UNDO.

FIND ae_Proposal WHERE ae_Proposal.ProposalID = iProposalID NO-LOCK NO-ERROR.
IF NOT AVAILABLE ae_Proposal THEN DO:
    cText = 'Error: Proposal not found'.
    cSource = 'TEMPLATE'.
    RETURN.
END.

dBase = ae_Proposal.BaseValue.
dProp = ae_Proposal.ProposedValue.

RUN ae_mockllm.p (INPUT 'good', OUTPUT cAiText).

RUN ae_check_numbers.p (INPUT cAiText, INPUT dBase, INPUT dProp, OUTPUT lPassed).

IF lPassed THEN DO:
    cText = cAiText.
    cSource = 'AI'.
END.
ELSE DO:
    cText = 'Your base price was R' + STRING(dBase) + ' and the proposed price is R' + STRING(dProp) + '.'.
    cSource = 'TEMPLATE'.
END.

CREATE ae_AiLog.
ASSIGN ae_AiLog.LogID    = NEXT-VALUE(ae_LogSeq)
       ae_AiLog.AiPoint  = 'Advocate'
       ae_AiLog.LoggedAt = NOW.

IF cSource = 'AI' THEN 
    ASSIGN ae_AiLog.AiResult = 'accepted'.
ELSE 
    ASSIGN ae_AiLog.AiResult = 'rejected'.
