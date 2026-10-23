Lesson 12 — Same Engine for Any Business
Built

    fp_Profile table — one row per business: name, unit, capacity, three prices, marginal cost, window hours

    seed_profile.p — three profiles: Bus, Hotel, Salon

    Updated sim_day.p to read from a profile instead of hardcoded numbers

    run_sim.p — runs the sim for one profile name

Logic

    Engine files (fp_floor.p, fp_price.p, fp_fairness.p) do not change between profiles

    Only the data changes: capacity, cost, prices, time window

    A 24-hour salon, a 168-hour hotel, and a 72-hour bus behave the same way when the same share of time remains

Profiles
Profile	Unit	Capacity	Prices	Cost	Window
Bus	seats	90	500 / 470 / 420	300	72h
Hotel	rooms	40	1200 / 1100 / 950	1100	168h
Salon	slots	12	250 / 230 / 200	60	24h
Challenges

    Data Dictionary cannot edit rows. The DD is for schema only. To change a profile value, either edit seed_profile.p and re-run, or write a small FIND … EXCLUSIVE-LOCK + ASSIGN script.

    WindowHours field missing. Error 201 "Unknown Field or Variable" — the field has to exist in the schema and be committed before the code compiles.

    Editor caches schema. After adding a field, close and reopen the Procedure Editor, otherwise the compiler still sees the old schema.

    TITLE / AT ROW / WITH FRAME in DISPLAY. Parser errors in this OpenEdge version. Simplest fix: one DISPLAY statement at the end, no frame options.

    DISPLAY overwrite. Two DISPLAY statements share one default frame — the second erases the first. Same problem we hit in Lesson 4.

Hotel Cost = R1,100 (Exercise 1)

    Floor becomes MAXIMUM(list × effPct, 1100)

    Late-day prices hold at R1,100 instead of dropping to R902.50

    dDiscountGiven goes negative when the floor is above list — the metric isn't designed for that case. Note it in the pitch, don't fix it now.

Unit Name in Feed (Exercise 2)

    fp_Profile.UnitName stored but unused until the feed appends it

    Feed grows from 12 to 13 elements — last one is the unit string

    Page reads it and updates the label: "Seats Sold" / "Rooms Sold" / "Slots Sold"

    Missing JS line breaks the row. If document.getElementById('mSeats').textContent is removed, the row stays at — / — even though the label updates.

Real Window Hours (Exercise 3)

    dWindow becomes an input to fp_floor.p instead of a fixed variable

    Every caller updates: fp_price.p, fp_decide.p, fp_ticket.p, sim_day.p, all tests

    Test files pass INPUT 72 — the neutral value that keeps old results identical

The Portability Claim

Same engine, different business. The floor formula doesn't care whether it's selling seats, rooms, or time slots. Only the profile changes.
The Honest Limitation

Simulated customers were generated at bus prices (R400–R550). Their spend thresholds are bus-shaped. Under the Hotel profile, a "Regular" customer with 3 bus bookings (R1,500 total) is a tiny fish. Say this out loud in the pitch: "Real data would bring its own thresholds."