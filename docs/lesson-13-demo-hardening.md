Lesson 13 — Demo Hardening
Built

    seed_demo.p — three fixed demo customers: Thandi Mokoena (1001), Sipho Ndlovu (1002), Lerato Dlamini (1003)

    sim_day.p — force arrival at ticks 12, 30, 45 so the demo always tells the same three stories

    demo.bat — launcher (browser + Proenv; no DB start — it's already running)

    check_demo.p — diagnostic that verifies the three demo rows

    run_seeds.p — optional runner; do not rely on it

The Three Stories
ID	Name	Segment	Fairness	Price	Perk
1001	Thandi Mokoena	Regular	RELEASE	R475	None
1002	Sipho Ndlovu	Regular	HOLD	R500	None
1003	Lerato Dlamini	New	RELEASE	R500	None or Voucher

Same segment, different price because of behaviour. That's the pitch.
Challenges

    Demo customers sometimes didn't appear. At tick 45 the trip was full, so the whole arrivals block was skipped. Fix: capacity bypass at demo ticks, plus iArrivals = MAXIMUM(iArrivals, 1).

    Names were random. seed_demo.p ran before gen_data.p, so gen_data.p overwrote the names. Fix: correct seed order.

    Seed order is critical.

        reset_sim.p

        gen_data.p

        seed_demo.p

    run_seeds.p fails on seed_credit.p. Not needed for the demo — comment it out. Don't debug it before the presentation.

    prowin fairplay -1 opens a Procedure Editor, not the database. The DB is started elsewhere. Remove it from demo.bat.

    Error 276 (database in use, multi-user mode). The DB was already running. The bat shouldn't start it.

    demo.bat running from the wrong folder. No "Start in" folder like a shortcut has. Fix: cd /d <path> first, or use absolute paths everywhere.

    Custom names in the log. Change sim_day.p so LogEvent prints ID Name instead of just the name. Guarantees a customer is identifiable even if the display name gets truncated.

The Demo Flow

Setup (once):

    reset_sim.p → run

    gen_data.p → run

    seed_demo.p → run

    check_demo.p → verify names

Live:

    Open fairplay_display.html

    Run run_sim.p with 'Bus'

    Watch Thandi at 10:00, Sipho at 13:00, Lerato at 15:30

Pre-Demo Checklist
text

[ ] test_all.p shows every PASS
[ ] Seeds run: reset_sim.p, gen_data.p, seed_demo.p
[ ] Full sim ends with units sold ≤ capacity, compensation > 0
[ ] Demo customers appear at ticks 12, 30, 45
[ ] Badge says LIVE SIMULATION, not REPLAY
[ ] Full screen, readable from a distance
[ ] Charger plugged in, sleep/screensaver/notifications off
[ ] Fallback clip opens in one click, copy on USB
[ ] Backup: project zip, fairplay.df, probkup copy — USB + cloud
[ ] Proenv and browser open, restart command ready

demo.bat — Final Shape
bat

@echo off
REM demo.bat - FairPlay launcher (DB assumed running)
start "" "%~dp0sim\fairplay_display.html"
start "" "C:\Progress\OpenEdge\bin\proenv.bat"
echo Demo launcher done.
pause

What's Frozen

After this lesson, fix bugs only. No new features. The demo is the artifact — protect it.
What's Left

    Record the fallback clip

    Back up everything (project, .df, probkup) to USB + cloud

    Time a full dry run with talk and trim to fit the slot

    Print the checklist and tick it before walking on stage