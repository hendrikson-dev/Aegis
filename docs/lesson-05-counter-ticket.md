Lesson 5 — The Counter Ticket
Built

    fp_ticket.p — one program that runs the whole pipeline and shows one ticket

    test_ticket.p — runs three customers in a row

Logic

    Inputs: customer, booking, value, list price, cost, last-seat flag

    Calls classify → fairness → price → comp_perk

    Prints a formatted ticket

Challenges

    PUT UNFORMATTED unreliable in the Procedure Editor. Some lines printed, others silently dropped.

    'Today's price' broke the parser — single quote is the string delimiter. Renamed to 'Current Price'.

    Output cut off on the right. The reason string is long. Either widen the window or reduce font size.

Notes

    For testing, DISPLAY was preferred. For final output, PUT UNFORMATTED. Different jobs.

    Keep an eye on the reason string length. If it exceeds the frame, the tail is invisible.