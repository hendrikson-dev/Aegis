Lesson 8 — Synthetic Data Generator
Built

    reset_sim.p — deletes simulated data (customers ≥ 1000, bookings ≥ 10000, behaviour ≥ 1000)

    gen_data.p — creates 200 customers with believable booking histories

Logic

    50% casual, 30% regular, 15% frequent, 5% heavy

    ~30% of customers with bookings get a behaviour record

    Names from a fixed list, bookings R400–R550, dates within last 120 days

Challenges

    RANDOM(seed) doesn't exist in this OpenEdge version. Removed the seed line — randomness is accepted.

    VIP count was zero. With MinSpend = R10000, no simulated customer qualified. Lowered to R7000 to get a small non-zero count.

    Data Dictionary cannot edit data rows. The DD is for schema. To change a data value, write a small ABL script that does FIND + ASSIGN + COMMIT.

Notes

    Simulated data lives in its own number ranges so it never touches test customers 1–3.

    Always label simulated data as simulated — on the slide and on the screen.