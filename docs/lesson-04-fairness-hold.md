Lesson 4 — Fairness Hold, Compensation, Perks
Built

    fp_fairness.p — reads behaviour records, returns RELEASE / HOLD / EXPLOIT

    fp_comp_perk.p — returns compensation (DECIMAL) and perk (CHARACTER) as separate outputs

    Updated fp_price.p to call fp_fairness.p and zero the discount on HOLD/EXPLOIT

    test_fairness.p, test_comp.p

Logic

    Risk ≥ 3 → EXPLOIT. Risk = 2 → HOLD. Else RELEASE

    HOLD/EXPLOIT → discount blocked, floor still applies

    Compensation = paid − list price, never below zero

    Perk only for RELEASE. Loyal/VIP → seat upgrade. Others on last seat → voucher

Challenges

    Spelling: schema uses fp_Behaviour (British). Guide used fp_Behavior. Every reference had to change.

    Wrong data type: BehaviourCode was INTEGER in the schema, but the guide assigns text. Fixed in Data Dictionary — changed to CHARACTER, format x(25).

    Error 223 (Incompatible data types) was reported on the ASSIGN line, not on the offending field. Misleading. Fix was in the schema, not the code.

    Reserved words: Status cannot be a field name. Used CreditState later for the same reason.

    Editor cache: after renaming a variable, the Procedure Editor keeps the old name. Close and reopen the editor to clear.

    DISPLAY overwrites: two DISPLAY statements back-to-back share one default frame — the second erases the first.

Notes

    test_all.p later became the safety net. Before that, every change was verified by hand.