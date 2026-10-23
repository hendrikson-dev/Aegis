Lesson 11 — Dynamic Floor
Built

    fp_floor.p — floor responds to time-to-departure and unsold seats

    Updated fp_price.p, fp_decide.p, fp_ticket.p, sim_day.p to pass dOccupancy and dHoursLeft

Logic

    Time factor: 0 far away, 1 at departure (over 72 hours)

    Unsold factor: 0 full, 1 empty

    Effective pct = segment floor × (1 − 0.5 × timeFactor × unsoldFactor)

    Floor = MAXIMUM(list × effective pct, marginal cost)

Challenges

    Parameter mismatches everywhere. Every caller of fp_price.p and fp_decide.p needed two new inputs. Six files changed.

    BY clause parser error. FOR EACH fp_Credit WHERE ... BY ExpiryDate EXCLUSIVE-LOCK fails in this OpenEdge version. Two fixes: drop the BY and sort via a temp-table primary index, or move the date filter inside the loop body.

    DEFINE VARIABLE inside IF blocks sometimes fails. Move all variable definitions to the top of the file.

    Test files broke. test_all.p uses INPUT 50, INPUT 999 as neutral values to keep old results identical.

Design Question (Unresolved)

    Report says 90% full / 2 days out should be near cost. The formula keeps that floor high. Two options:

        Keep the formula. A nearly full trip doesn't need to cut price.

        Change the formula. Time pressure dominates; drop the unsold factor.

    Current stance: keep the formula. The report's claim is what needs editing, not the code.

Notes

    The neutral values (occupancy 50, hours 999) preserve old behaviour. This is how you add a parameter without breaking callers.

    Dynamic floor is what makes late-day pricing competitive without sacrificing margin early.