DEFINE BUFFER bCust FOR fp_Customer.
DEFINE VARIABLE iRows AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSeg  AS CHARACTER NO-UNDO.
DEFINE VARIABLE dScr  AS DECIMAL   NO-UNDO.



FOR EACH fp_Customer NO-LOCK:
    iRows = 0.
    FOR EACH bCust WHERE bCust.CustNum = fp_Customer.CustNum NO-LOCK:
        iRows = iRows + 1.
    END.
    RUN fp_classify.p (INPUT fp_Customer.CustNum, OUTPUT cSeg, OUTPUT dScr).
    DISPLAY 'Cust ' + STRING(fp_Customer.CustNum) FORMAT 'x(8)'
          iRows FORMAT '9'
          cSeg FORMAT 'x(10)'.
END.   
