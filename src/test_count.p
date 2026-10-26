DEFINE VARIABLE iPass   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iFail   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cLog    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iProp   AS INTEGER   NO-UNDO.
DEFINE VARIABLE oWarr   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBefore AS INTEGER   NO-UNDO.
DEFINE VARIABLE iAfter  AS INTEGER   NO-UNDO.
DEFINE VARIABLE cRul    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCls    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRec    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOld    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNew    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lOk     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lMatch  AS LOGICAL   NO-UNDO.

PROCEDURE Check:
    DEFINE INPUT PARAMETER pName AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pOk   AS LOGICAL   NO-UNDO.
    IF pOk THEN iPass = iPass + 1. ELSE iFail = iFail + 1.
    cLog = cLog + (IF pOk THEN 'PASS  ' ELSE 'FAIL  ') + pName + CHR(10).
END PROCEDURE.

PROCEDURE NewProp:
    DEFINE INPUT  PARAMETER pBase  AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pProp  AS DECIMAL NO-UNDO.
    DEFINE INPUT  PARAMETER pFloor AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER pID    AS INTEGER NO-UNDO.
    DO TRANSACTION:
        CREATE ae_Proposal.
        ASSIGN ae_Proposal.ProposalID    = NEXT-VALUE(ae_ProposalSeq)
               ae_Proposal.Engine        = 'Strategy'
               ae_Proposal.BaseValue     = pBase
               ae_Proposal.ProposedValue = pProp
               ae_Proposal.FloorValue    = pFloor.
        pID = ae_Proposal.ProposalID.
    END.
END PROCEDURE.

PROCEDURE CountW:
    DEFINE OUTPUT PARAMETER pN AS INTEGER NO-UNDO.
    pN = 0.
    FOR EACH ae_Warrant NO-LOCK: pN = pN + 1. END.
END PROCEDURE.

RUN NewProp (INPUT 500, INPUT 540, INPUT 300, OUTPUT iProp).
RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
RUN Check (INPUT '1. Fair rise admitted', INPUT (cRul = 'Admit')).

RUN NewProp (INPUT 500, INPUT 700, INPUT 300, OUTPUT iProp).
RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
RUN Check (INPUT '2. Over the cap denied under PR-1', INPUT (cRul = 'Deny' AND cCls = 'PR-1')).

RUN ae_steward.p (INPUT iProp, INPUT 'Surge', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
RUN Check (INPUT '3. Surge admits what Normal denied', INPUT (cRul = 'Admit')).

RUN NewProp (INPUT 500, INPUT 280, INPUT 300, OUTPUT iProp).
RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
RUN Check (INPUT '4. Below the floor denied under PR-3', INPUT (cRul = 'Deny' AND cCls = 'PR-3')).

RUN NewProp (INPUT 500, INPUT 700, INPUT 300, OUTPUT iProp).
RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT 'Deny', INPUT 'Over cap', INPUT 'PR-1', OUTPUT oWarr).
FIND ae_Exception WHERE ae_Exception.WarrantID = oWarr NO-LOCK NO-ERROR.
lOk = FALSE.
IF AVAILABLE ae_Exception THEN lOk = (ae_Exception.ExcState = 'Open').
RUN Check (INPUT '5. Denial sealed and exception opened', INPUT lOk).

RUN CountW (OUTPUT iBefore).
RUN NewProp (INPUT 500, INPUT 540, INPUT 300, OUTPUT iProp).
RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT 'InvalidRuling', INPUT 'Test', INPUT 'PR-1', OUTPUT oWarr) NO-ERROR.
RUN CountW (OUTPUT iAfter).
RUN Check (INPUT '6. Forced failure saves nothing', INPUT (iBefore = iAfter)).

RUN ae_check_numbers.p (INPUT 'You were charged R500 and the new price is R400.', INPUT 500, INPUT 400, OUTPUT lOk).
RUN Check (INPUT '7. Correct numbers accepted', INPUT lOk).

RUN ae_check_numbers.p (INPUT 'You were charged R500.00 and the new price is R400.00.', INPUT 500, INPUT 400, OUTPUT lOk).
RUN Check (INPUT '8. Decimals accepted', INPUT lOk).

RUN ae_check_numbers.p (INPUT 'You were charged R500 and the new price is R999.', INPUT 500, INPUT 400, OUTPUT lOk).
RUN Check (INPUT '9. Invented number rejected', INPUT (NOT lOk)).

RUN NewProp (INPUT 500, INPUT 540, INPUT 300, OUTPUT iProp).
RUN ae_steward.p (INPUT iProp, INPUT 'Normal', OUTPUT cRul, OUTPUT cWhy, OUTPUT cCls).
RUN ae_seal.p (INPUT iProp, INPUT 'Normal', INPUT cRul, INPUT cWhy, INPUT cCls, OUTPUT oWarr).
RUN ae_replay.p (INPUT oWarr, OUTPUT lMatch, OUTPUT cOld, OUTPUT cNew).
RUN Check (INPUT '10. Replay gives the same ruling', INPUT lMatch).

RUN ae_concierge.p (INPUT oWarr, OUTPUT cRec).
RUN Check (INPUT '11. Receipt names the rule applied', INPUT (INDEX(cRec, cCls) > 0)).

lOk = TRUE.
FOR EACH ae_Warrant NO-LOCK WHERE LOOKUP(ae_Warrant.Ruling, 'Admit,Deny,Override') = 0:
    lOk = FALSE.
END.
RUN Check (INPUT '12. Every Warrant has a valid ruling', INPUT lOk).

MESSAGE cLog SKIP STRING(iPass) + ' PASS, ' + STRING(iFail) + ' FAIL'
    VIEW-AS ALERT-BOX INFORMATION TITLE 'Aegis tests that count'.
