DEFINE INPUT  PARAMETER iCustNum AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER dPrice   AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER dCost    AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER bCommit  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER dApplied AS DECIMAL   NO-UNDO.
DEFINE OUTPUT PARAMETER dCashDue AS DECIMAL   NO-UNDO.

DEFINE VARIABLE dBalance    AS DECIMAL NO-UNDO.
DEFINE VARIABLE dCreditable AS DECIMAL NO-UNDO.
DEFINE VARIABLE dRemaining  AS DECIMAL NO-UNDO.
DEFINE VARIABLE dToday      AS DATE    NO-UNDO.

DEFINE TEMP-TABLE ttCredit NO-UNDO
    FIELD CreditID   AS INTEGER
    FIELD ExpiryDate AS DATE
    INDEX ixExp IS PRIMARY ExpiryDate CreditID.

RUN fp_wallet.p (INPUT iCustNum, OUTPUT dBalance).

dCreditable = MAXIMUM(0, dPrice - dCost).

dApplied = MINIMUM(dBalance, dCreditable).
dCashDue = dPrice - dApplied.

IF bCommit AND dApplied > 0 THEN DO:
    dRemaining = dApplied.
    dToday = TODAY.

    FOR EACH fp_Credit WHERE fp_Credit.CustNum    = iCustNum
                         AND fp_Credit.CreditState = 'Open'
                         NO-LOCK:
        IF fp_Credit.ExpiryDate < dToday THEN NEXT.
        CREATE ttCredit.
        ASSIGN ttCredit.CreditID   = fp_Credit.CreditID
               ttCredit.ExpiryDate = fp_Credit.ExpiryDate.
    END.

    FOR EACH ttCredit:
        IF dRemaining <= 0 THEN LEAVE.

        FIND fp_Credit WHERE fp_Credit.CreditID = ttCredit.CreditID EXCLUSIVE-LOCK NO-ERROR.
        IF NOT AVAILABLE fp_Credit THEN NEXT.

        IF fp_Credit.Amount <= dRemaining THEN DO:
            dRemaining = dRemaining - fp_Credit.Amount.
            ASSIGN fp_Credit.CreditState = 'Used'.
        END.
        ELSE DO:
            fp_Credit.Amount = fp_Credit.Amount - dRemaining.
            dRemaining = 0.
        END.
    END.
END.
