Lesson 7 — Bug Day + Self-Checking Test
Built

    test_all.p — runs nine checks, prints PASS or FAIL on each

Logic

    Each test runs one program and compares the output to an expected value

    Uses IF ... THEN 'PASS' ELSE 'FAIL' to build a result string

    All results shown in one DISPLAY at the end

Challenges

    PUT UNFORMATTED again failed. Replaced with one DISPLAY statement at the end. Single frame, no overwrite.

    Frame too narrow. Default CHARACTER width is 8 chars. Added FORMAT "x(60)" on each result variable to widen the frame.

    1 column layout. Without 1 COLUMN, DISPLAY put all results on one row and cut them off. Forced vertical layout.

Notes

    This file is now the safety net. Run it before any demo, backup, or change.

    All nine tests must PASS. If one fails, fix it before moving on.