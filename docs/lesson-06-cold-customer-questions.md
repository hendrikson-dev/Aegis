Lesson 6 — Six Questions for a Cold Customer
Built

    fp_questions.p — six yes/no dialogs, evaluates answers, writes a behaviour record

    test_questions.p — resets Customer 3, runs the questionnaire, then shows the ticket

Logic

    If the customer already has a behaviour record, skip the questions and return what's known

    Q5=Yes and Q3=No → PLANNED_TO_WAIT (risk 2, or risk 1 if Q4=Yes)

    Q2=Yes and Q3=Yes → VIEWED_THEN_LEFT (risk 0)

    Everything else → NO_SIGNAL (risk 0)

Challenges

    "Skipping saves nothing" — if the customer skipped, no record was saved, so they'd be asked again next time. Fix: write a NO_SIGNAL record even on skip.

    UNKNOWN logical values. Clicking X on a message box returns ?, not NO. IF NOT bAns evaluates ? as false, so the code continued into the questions. Fix: IF bAns <> TRUE THEN catches both NO and UNKNOWN.

    Proper start gate. Asking "Is this your first time?" as the entry point was bad UX. Added a separate start prompt before any questions.

Notes

    Behaviour records are now permanent for the customer. The engine will use them on every future booking.

    The questionnaire only fires for "cold" customers — no existing behaviour record.