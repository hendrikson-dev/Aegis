Lesson 9 — Simulated Business Day
Built

    fp_decide.p — silent decision engine (no DISPLAY, returns everything)

    sim_day.p — 60 ticks, 08:00 → 17:50, price drops at 12:00 and 14:00

    Logs to sim_log.txt

Logic

    90-seat capacity, R300 marginal cost

    Random arrivals, busier between 10:00 and 13:00

    On price drop: sweep all prior bookings, pay back the delta

    Manager override at tick 40 (14:30): releases the most recent hold

Challenges

    PAUSE freezes when window loses focus. The Procedure Editor only counts seconds while it's in the foreground. Fix: use PROCESS EVENTS loop, or set iPause = 0 for fast test runs.

    Parameter mismatches. Every caller of fp_decide.p or fp_price.p had to update when signatures changed. Error 3234 names the file — fix the first one, re-run, repeat.

    Buffer names matter. The override needs bOvr (a second buffer on ttOrder), not the default buffer, to avoid scope errors.

Notes

    The sim is the showcase demo. It runs the full engine end to end.

    Numbers should be roughly: 80–90 seats sold, R37,000–R40,000 revenue.