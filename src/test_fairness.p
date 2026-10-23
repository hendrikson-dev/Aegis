DEFINE VARIABLE cFair AS CHARACTER NO-UNDO.


FOR EACH fp_Customer NO-LOCK:
    RUN fp_fairness.p (INPUT fp_Customer.CustNum, OUTPUT cFair).
    DISPLAY fp_Customer.CustNum cFair.
END.
