DEFINE VARIABLE iProp AS INTEGER   NO-UNDO.
DEFINE VARIABLE oWarr AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCount AS INTEGER  NO-UNDO.

MESSAGE 'Starting Seal Tests...' VIEW-AS ALERT-BOX.

CREATE ae_Proposal.
ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
       ae_Proposal.Engine        = 'Strategy'
       ae_Proposal.BaseValue     = 500
       ae_Proposal.ProposedValue = 700
       ae_Proposal.FloorValue    = 300.
iProp = ae_Proposal.ProposalID.

RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT 'Deny', INPUT 'Over Cap', INPUT 'PR-1', OUTPUT oWarr).

FIND FIRST ae_Warrant WHERE ae_Warrant.WarrantID = oWarr NO-LOCK NO-ERROR.
IF AVAILABLE ae_Warrant THEN DO:
    FIND FIRST ae_Exception WHERE ae_Exception.WarrantID = oWarr NO-LOCK NO-ERROR.
    IF AVAILABLE ae_Exception AND ae_Exception.ExcState = 'Open' THEN
        MESSAGE 'T11 PASS: Denial sealed and Exception opened.' VIEW-AS ALERT-BOX INFO.
    ELSE
        MESSAGE 'T11 FAIL: Exception not found.' VIEW-AS ALERT-BOX ERROR.
END.
ELSE DO:
    MESSAGE 'T11 FAIL: Warrant not found.' VIEW-AS ALERT-BOX ERROR.
END.

MESSAGE 'Now testing T5 (Forced Failure). Expect an error popup next.' VIEW-AS ALERT-BOX.

RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT 'InvalidRuling', INPUT 'Test', INPUT 'Test', OUTPUT oWarr) NO-ERROR.

IF ERROR-STATUS:ERROR OR ERROR-STATUS:GET-MESSAGE(1) <> '' THEN DO:
    iCount = 0.
    FOR EACH ae_Warrant NO-LOCK:
        iCount = iCount + 1.
    END.
    
    IF iCount = 1 THEN
        MESSAGE 'T5 PASS: Error caught, transaction rolled back safely. Total Warrants: ' + STRING(iCount) VIEW-AS ALERT-BOX INFO.
    ELSE
        MESSAGE 'T5 FAIL: A half-write occurred! Total Warrants: ' + STRING(iCount) VIEW-AS ALERT-BOX ERROR.
END.
