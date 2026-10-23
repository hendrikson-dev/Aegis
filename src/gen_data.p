DEFINE VARIABLE iCust    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRoll    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBooks   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iB       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iNextBk  AS INTEGER   NO-UNDO INITIAL 10000.
DEFINE VARIABLE iNextBeh AS INTEGER   NO-UNDO INITIAL 1000.
DEFINE VARIABLE iTotBk   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iTotBeh  AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSeg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScr     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iNew     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iReg     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLoy     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iVip     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iOther   AS INTEGER   NO-UNDO.


FOR EACH fp_Booking WHERE fp_Booking.BookingNum >= 10000 EXCLUSIVE-LOCK:
    DELETE fp_Booking.
END.
FOR EACH fp_Behaviour WHERE fp_Behaviour.BehaviourID >= 1000 EXCLUSIVE-LOCK:
    DELETE fp_Behaviour.
END.
FOR EACH fp_Customer WHERE fp_Customer.CustNum >= 1000 EXCLUSIVE-LOCK:
    DELETE fp_Customer.
END.

DO iCust = 1001 TO 1200:

    CREATE fp_Customer.
    ASSIGN fp_Customer.CustNum = iCust
           fp_Customer.Name    = ENTRY(RANDOM(1, 10), 'Thandi,Sipho,Lerato,Johan,Naledi,Pieter,Ayanda,Zanele,Kabelo,Mpho')
                                 + ' ' + ENTRY(RANDOM(1, 10), 'Mokoena,Ndlovu,Dlamini,Van Der Merwe,Khumalo,Botha,Nkosi,Zulu,Naidoo,Pillay')
           fp_Customer.RegDate = TODAY - RANDOM(30, 400).

    iRoll = RANDOM(1, 100).
    IF iRoll <= 50 THEN
        iBooks = RANDOM(0, 2).
    ELSE IF iRoll <= 80 THEN
        iBooks = RANDOM(3, 7).
    ELSE IF iRoll <= 95 THEN
        iBooks = RANDOM(8, 14).
    ELSE
        iBooks = RANDOM(15, 20).

    DO iB = 1 TO iBooks:
        iNextBk = iNextBk + 1.
        CREATE fp_Booking.
        ASSIGN fp_Booking.BookingNum = iNextBk
               fp_Booking.CustNum    = iCust
               fp_Booking.PricePaid  = 400 + RANDOM(0, 150)
               fp_Booking.BookDate   = TODAY - RANDOM(1, 120).
    END.
    iTotBk = iTotBk + iBooks.

    IF iBooks > 0 AND RANDOM(1, 100) <= 30 THEN DO:
        iNextBeh = iNextBeh + 1.
        iRoll = RANDOM(1, 100).
        CREATE fp_Behaviour.
        ASSIGN fp_Behaviour.BehaviourID      = iNextBeh
               fp_Behaviour.CustNum          = iCust
               fp_Behaviour.BookingBehaviour = 'Simulated'.
        IF RANDOM(1, 100) <= 10 THEN
    ASSIGN fp_Behaviour.ActiveStatus = 'Inactive'.
        ELSE
    ASSIGN fp_Behaviour.ActiveStatus = 'Active'.       
        IF iRoll <= 60 THEN
            ASSIGN fp_Behaviour.RiskLevel     = 0
                   fp_Behaviour.BehaviourCode = 'VIEWED_THEN_LEFT'
                   fp_Behaviour.Description   = 'Simulated: saw the higher price and left'.
        ELSE IF iRoll <= 90 THEN
            ASSIGN fp_Behaviour.RiskLevel     = 2
                   fp_Behaviour.BehaviourCode = 'NEVER_VIEWED_HIGH'
                   fp_Behaviour.Description   = 'Simulated: never viewed the higher price'.
        ELSE
            ASSIGN fp_Behaviour.RiskLevel     = 3
                   fp_Behaviour.BehaviourCode = 'REPEAT_WAITER'
                   fp_Behaviour.Description   = 'Simulated: repeatedly waits for drops'.
        iTotBeh = iTotBeh + 1.
    END.
END.

FOR EACH fp_Customer WHERE fp_Customer.CustNum >= 1000 NO-LOCK:
    RUN fp_classify.p (INPUT fp_Customer.CustNum, OUTPUT cSeg, OUTPUT dScr).
    CASE cSeg:
        WHEN 'New'     THEN iNew = iNew + 1.
        WHEN 'Regular' THEN iReg = iReg + 1.
        WHEN 'Loyal'   THEN iLoy = iLoy + 1.
        WHEN 'VIP'     THEN iVip = iVip + 1.
        OTHERWISE iOther = iOther + 1.
    END CASE.
END.

MESSAGE 'SIMULATED DATA CREATED' + CHR(10)
      + 'Customers: 200   Bookings: ' + STRING(iTotBk) + '   Behaviour records: ' + STRING(iTotBeh) + CHR(10)
      + 'New ' + STRING(iNew) + ' | Regular ' + STRING(iReg) + ' | Loyal ' + STRING(iLoy)
      + ' | VIP ' + STRING(iVip) + ' | Other ' + STRING(iOther)
      VIEW-AS ALERT-BOX INFORMATION.
