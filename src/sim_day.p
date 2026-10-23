DEFINE INPUT PARAMETER cProfile AS CHARACTER NO-UNDO.

DEFINE TEMP-TABLE ttOrder NO-UNDO
    FIELD BookingNum AS INTEGER
    FIELD CustNum    AS INTEGER
    FIELD Paid       AS DECIMAL
    FIELD CompPaid   AS DECIMAL
    FIELD Held       AS LOGICAL
    FIELD Blocked    AS DECIMAL
    INDEX ixBook IS PRIMARY UNIQUE BookingNum.

DEFINE BUFFER bSweep FOR ttOrder.
DEFINE BUFFER bOvr   FOR ttOrder.
DEFINE STREAM sLog.
DEFINE STREAM sFeed.
DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
DEFINE VARIABLE iDone   AS INTEGER   NO-UNDO.

DEFINE VARIABLE iCapacity    AS INTEGER   NO-UNDO.
DEFINE VARIABLE dCost        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iPause       AS INTEGER   NO-UNDO INITIAL 1.
DEFINE VARIABLE iOverrideAt  AS INTEGER   NO-UNDO INITIAL 40.
DEFINE VARIABLE iWindowHours AS INTEGER   NO-UNDO.
DEFINE VARIABLE cUnit        AS CHARACTER NO-UNDO.

DEFINE VARIABLE dStart      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDrop1      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDrop2      AS DECIMAL   NO-UNDO.

DEFINE VARIABLE iTick       AS INTEGER NO-UNDO.
DEFINE VARIABLE iMin        AS INTEGER NO-UNDO.
DEFINE VARIABLE iHH         AS INTEGER NO-UNDO.
DEFINE VARIABLE iMM         AS INTEGER NO-UNDO.
DEFINE VARIABLE iArrivals   AS INTEGER NO-UNDO.
DEFINE VARIABLE iA          AS INTEGER NO-UNDO.
DEFINE VARIABLE iCust       AS INTEGER NO-UNDO.
DEFINE VARIABLE cCustName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iNextBook   AS INTEGER NO-UNDO INITIAL 20000.
DEFINE VARIABLE iSold       AS INTEGER NO-UNDO.
DEFINE VARIABLE iHolds      AS INTEGER NO-UNDO.
DEFINE VARIABLE iOverrides  AS INTEGER NO-UNDO.
DEFINE VARIABLE iCompBooks  AS INTEGER NO-UNDO.
DEFINE VARIABLE dList       AS DECIMAL NO-UNDO.
DEFINE VARIABLE dLastList   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dRevenue    AS DECIMAL NO-UNDO.
DEFINE VARIABLE dCompTotal  AS DECIMAL NO-UNDO.
DEFINE VARIABLE dCompDrop   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dWithheld   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dDiscountGiven AS DECIMAL NO-UNDO.
DEFINE VARIABLE dOverrideCost AS DECIMAL NO-UNDO.
DEFINE VARIABLE dAvgPrice   AS DECIMAL NO-UNDO.
DEFINE VARIABLE dOcc        AS DECIMAL NO-UNDO.
DEFINE VARIABLE dHrs        AS DECIMAL NO-UNDO.
DEFINE VARIABLE dCurFloor   AS DECIMAL NO-UNDO.
DEFINE VARIABLE cSeg        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFair       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPerk       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cWhy        AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScr        AS DECIMAL NO-UNDO.
DEFINE VARIABLE dFinal      AS DECIMAL NO-UNDO.
DEFINE VARIABLE dComp       AS DECIMAL NO-UNDO.
DEFINE VARIABLE dBlocked    AS DECIMAL NO-UNDO.
DEFINE VARIABLE bLast       AS LOGICAL NO-UNDO.

DEFINE VARIABLE cBaseDir AS CHARACTER NO-UNDO.
DEFINE VARIABLE cSimDir  AS CHARACTER NO-UNDO.

cBaseDir = SESSION:PARAMETER.
IF cBaseDir = "" OR cBaseDir = ? THEN 
    cBaseDir = ".".

cSimDir = cBaseDir + "\sim".

FIND fp_Profile WHERE fp_Profile.ProfileName = cProfile NO-LOCK NO-ERROR.

IF NOT AVAILABLE fp_Profile THEN DO:
    MESSAGE 'Profile ' + cProfile + ' was not found.' VIEW-AS ALERT-BOX ERROR.
    RETURN.
END.


ASSIGN iCapacity    = fp_Profile.Capacity
       dCost        = fp_Profile.MarginalCost
       dStart       = fp_Profile.StartPrice
       dDrop1       = fp_Profile.Drop1Price
       dDrop2       = fp_Profile.Drop2Price
       dLastList    = fp_Profile.StartPrice
       iWindowHours = fp_Profile.WindowHours
       cUnit        = fp_Profile.UnitName.

FOR EACH fp_Booking WHERE fp_Booking.BookingNum >= 20000 EXCLUSIVE-LOCK:
    DELETE fp_Booking.
END.
FOR EACH fp_Credit WHERE fp_Credit.SourceBooking >= 20000 EXCLUSIVE-LOCK:
    DELETE fp_Credit.
END.

OUTPUT STREAM sLog TO VALUE(cSimDir + '\sim_log.txt').
PUT STREAM sLog UNFORMATTED 'FAIRPLAY SIMULATED DAY - ' + cProfile + ' (simulated data)' SKIP.

DO iTick = 1 TO 60:

    iMin = 480 + (iTick - 1) * 10.
    iHH  = TRUNCATE(iMin / 60, 0).
    iMM  = iMin MODULO 60.

    dOcc = 100 * iSold / iCapacity.
    dHrs = iWindowHours * (60 - iTick) / 60.

    IF iMin < 720 THEN
        dList = dStart.
    ELSE IF iMin < 840 THEN
        dList = dDrop1.
    ELSE
        dList = dDrop2.

    IF dList < dLastList THEN DO:
        RUN fp_floor.p (INPUT dList, INPUT dCost, INPUT 85,
                        INPUT dOcc, INPUT dHrs, INPUT iWindowHours,
                        OUTPUT dCurFloor).
        RUN LogEvent (INPUT 'DROP',
                      INPUT 'Price drops to R' + TRIM(STRING(dList, '>>>,>>9.99'))
                            + ' | floor R' + TRIM(STRING(dCurFloor, '>>>,>>9.99'))
                            + ' | occ ' + TRIM(STRING(dOcc, '>>9.99')) + '%').
        iCompBooks = 0.
        dCompDrop  = 0.
        FOR EACH bSweep:
            RUN fp_comp_perk.p (INPUT bSweep.CustNum, INPUT bSweep.BookingNum,
                                INPUT dList, INPUT dList,
                                INPUT NO, INPUT 'HOLD',
                                OUTPUT dComp, OUTPUT cPerk).

            IF dComp > bSweep.CompPaid THEN DO:
                dCompDrop  = dCompDrop + (dComp - bSweep.CompPaid).
                iCompBooks = iCompBooks + 1.
                bSweep.CompPaid = dComp.
            END.
        END.
        dCompTotal = dCompTotal + dCompDrop.
        IF iCompBooks > 0 THEN
            RUN LogEvent (INPUT 'COMP', INPUT 'Would owe ' + STRING(iCompBooks) + ' early buyers: R'
                                              + TRIM(STRING(dCompDrop, '>>>,>>9.99'))).
        dLastList = dList.
    END.

        IF iSold < iCapacity THEN DO:
        IF iMin >= 600 AND iMin < 780 THEN
            iArrivals = RANDOM(1, 4).
        ELSE
            iArrivals = RANDOM(0, 2).

        IF iTick = 12 OR iTick = 30 OR iTick = 45 THEN
            iArrivals = MAXIMUM(iArrivals, 1).

        DO iA = 1 TO iArrivals:
            iCust = 1000 + RANDOM(1, 200).

            /* --- DEMO CUSTOMERS START --- */
            IF iA = 1 AND iTick = 12 THEN iCust = 1001.
            IF iA = 1 AND iTick = 30 THEN iCust = 1002.
            IF iA = 1 AND iTick = 45 THEN iCust = 1003.
            /* --- DEMO CUSTOMERS END (don't forget) --- */

            IF NOT (iA = 1 AND (iTick = 12 OR iTick = 30 OR iTick = 45)) THEN
                IF iSold >= iCapacity THEN LEAVE.

            bLast = (iCapacity - iSold) <= 12.

            RUN fp_decide.p (INPUT iCust, INPUT 0, INPUT dList, INPUT dCost, INPUT bLast,
                             INPUT dOcc, INPUT dHrs, INPUT iWindowHours,
                             OUTPUT cSeg, OUTPUT dScr, OUTPUT cFair, OUTPUT dFinal,
                             OUTPUT dComp, OUTPUT cPerk, OUTPUT dBlocked, OUTPUT cWhy).

            iNextBook = iNextBook + 1.
            DO TRANSACTION:
                CREATE fp_Booking.
                ASSIGN fp_Booking.BookingNum = iNextBook
                       fp_Booking.CustNum    = iCust
                       fp_Booking.PricePaid  = dFinal
                       fp_Booking.BookDate   = TODAY.
            END.

            CREATE ttOrder.
            ASSIGN ttOrder.BookingNum = iNextBook
                   ttOrder.CustNum    = iCust
                   ttOrder.Paid       = dFinal
                   ttOrder.CompPaid   = 0
                   ttOrder.Held       = (cFair = 'HOLD' OR cFair = 'EXPLOIT')
                   ttOrder.Blocked    = dBlocked.

            ASSIGN iSold    = iSold + 1
                   dRevenue = dRevenue + dFinal
                   dDiscountGiven = dDiscountGiven + (dList - dFinal).

            IF ttOrder.Held THEN
                ASSIGN iHolds    = iHolds + 1
                       dWithheld = dWithheld + dBlocked.

            FIND fp_Customer WHERE fp_Customer.CustNum = iCust NO-LOCK NO-ERROR.
            IF AVAILABLE fp_Customer THEN
                cCustName = fp_Customer.Name.
            ELSE
                cCustName = 'Cust ' + STRING(iCust).

            RUN LogEvent (INPUT (IF ttOrder.Held THEN 'HOLD' ELSE 'ORDER'),
                          INPUT STRING(iCust) + ' ' + cCustName + ' | ' + cSeg + ' | ' + cFair
                                + ' | R' + TRIM(STRING(dFinal, '>>>,>>9.99')) + ' | perk ' + cPerk).
        END.
    END.

    IF iTick = iOverrideAt THEN DO:
        FIND LAST bOvr WHERE bOvr.Held = TRUE NO-ERROR.
        IF AVAILABLE bOvr THEN DO:
            ASSIGN iOverrides    = iOverrides + 1
                   dOverrideCost = dOverrideCost + bOvr.Blocked
                   dWithheld     = dWithheld - bOvr.Blocked
                   bOvr.Held     = FALSE.
            RUN LogEvent (INPUT 'OVERRIDE',
                          INPUT 'Manager released the hold on Cust ' + STRING(bOvr.CustNum)
                                + ' (reason: long-standing customer), R'
                                + TRIM(STRING(bOvr.Blocked, '>>>,>>9.99')) + ' returned').
        END.
    END.

    RUN WriteFeed.

    STATUS INPUT 'Simulated ' + STRING(iHH, '99') + ':' + STRING(iMM, '99')
                 + ' | sold ' + STRING(iSold) + ' | compensation R'
                 + TRIM(STRING(dCompTotal, '>>>,>>9.99')).
    IF iPause > 0 THEN PAUSE iPause NO-MESSAGE.
END.

iDone = 1.
RUN WriteFeed.

STATUS INPUT OFF.

PUT STREAM sLog UNFORMATTED SKIP(1) 'END OF DAY - ' + cProfile SKIP
    'Units sold: ' + STRING(iSold) + ' of ' + STRING(iCapacity) + ' ' + cUnit SKIP
    'Revenue: R' + TRIM(STRING(dRevenue, '>>>,>>>,>>9.99')) SKIP
    'Discounts given: R' + TRIM(STRING(dDiscountGiven, '>>>,>>>,>>9.99')) SKIP
    'Discounts withheld: R' + TRIM(STRING(dWithheld, '>>>,>>>,>>9.99')) SKIP
    'Compensation reported: R' + TRIM(STRING(dCompTotal, '>>>,>>>,>>9.99')) SKIP
    'Fairness holds: ' + STRING(iHolds) SKIP
    'Manager overrides: ' + STRING(iOverrides) SKIP.
OUTPUT STREAM sLog CLOSE.

MESSAGE 'SIMULATED DAY COMPLETE - ' + cProfile + CHR(10)
      + 'Units sold: ' + STRING(iSold) + ' of ' + STRING(iCapacity) + ' ' + cUnit + CHR(10)
      + 'Revenue: R' + TRIM(STRING(dRevenue, '>>>,>>>,>>9.99')) + CHR(10)
      + 'Discounts given: R' + TRIM(STRING(dDiscountGiven, '>>>,>>>,>>9.99')) + CHR(10)
      + 'Discounts withheld: R' + TRIM(STRING(dWithheld, '>>>,>>>,>>9.99')) + CHR(10)
      + 'Compensation reported: R' + TRIM(STRING(dCompTotal, '>>>,>>>,>>9.99')) + CHR(10)
      + 'Fairness holds: ' + STRING(iHolds) + CHR(10)
      + 'Manager overrides: ' + STRING(iOverrides)
      VIEW-AS ALERT-BOX INFORMATION.

PROCEDURE LogEvent:
    DEFINE INPUT PARAMETER cKind AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER cText AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTime AS CHARACTER NO-UNDO.

    cTime = STRING(iHH, '99') + ':' + STRING(iMM, '99').
    PUT STREAM sLog UNFORMATTED cTime + '  ' + cKind + '  ' + cText SKIP.

    cEvents = cEvents + (IF cEvents = '' THEN '' ELSE '#') + cTime + '^' + cKind + '^' + cText.
    IF NUM-ENTRIES(cEvents, '#') > 12 THEN
        cEvents = SUBSTRING(cEvents, INDEX(cEvents, '#') + 1).
END PROCEDURE.

PROCEDURE WriteFeed:
    IF iSold > 0 THEN
        dAvgPrice = dRevenue / iSold.
    ELSE
        dAvgPrice = 0.

    OUTPUT STREAM sFeed TO VALUE(cSimDir + '\feed.js').
    PUT STREAM sFeed UNFORMATTED
        'window.FAIRPLAY = ["' + STRING(iHH, '99') + ':' + STRING(iMM, '99') + '",'
        + TRIM(STRING(dList, '>>>>>9.99')) + ','
        + TRIM(STRING(iSold, '>>>>>9')) + ',' + TRIM(STRING(iCapacity, '>>>>>9')) + ','
        + TRIM(STRING(dRevenue, '>>>>>>>9.99')) + ','
        + TRIM(STRING(dCompTotal, '>>>>>>>9.99')) + ','
        + TRIM(STRING(dWithheld, '->>>>>>9.99')) + ','
        + TRIM(STRING(iHolds, '>>>>>9')) + ',' + TRIM(STRING(iOverrides, '>>>>>9')) + ','
        + TRIM(STRING(dAvgPrice, '>>>>>>>9.99')) + ','
        + '"' + cEvents + '",' + STRING(iDone) + ',"' + cUnit + '"];' SKIP.
    OUTPUT STREAM sFeed CLOSE.
END PROCEDURE.
