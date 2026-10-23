DEFINE VARIABLE lPass AS LOGICAL NO-UNDO.

RUN ae_check_numbers.p (INPUT "You were charged R500 and the new price is R400.", INPUT 500, INPUT 400, OUTPUT lPass).
IF lPass THEN MESSAGE "T6 PASS: Safe text accepted." VIEW-AS ALERT-BOX.
ELSE MESSAGE "T6 FAIL." VIEW-AS ALERT-BOX ERROR.

RUN ae_check_numbers.p (INPUT "You were charged R500.00 and the new price is R400.00.", INPUT 500, INPUT 400, OUTPUT lPass).
IF lPass THEN MESSAGE "T6b PASS: Decimals accepted." VIEW-AS ALERT-BOX.
ELSE MESSAGE "T6b FAIL." VIEW-AS ALERT-BOX ERROR.

RUN ae_check_numbers.p (INPUT "You were charged R500 and the new price is R999.", INPUT 500, INPUT 400, OUTPUT lPass).
IF NOT lPass THEN MESSAGE "T7 PASS: Hallucinated number rejected." VIEW-AS ALERT-BOX.
ELSE MESSAGE "T7 FAIL." VIEW-AS ALERT-BOX ERROR.
