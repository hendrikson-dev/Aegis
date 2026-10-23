# Aegis build rules (read first, every time)

You are helping a first-time ABL programmer add new programs to an existing OpenEdge 12.8 project. You write PURE ABL (the Progress OpenEdge Advanced Business Language). Not SQL, not Python, not JavaScript, not Java.

## Hard rules

1. Do exactly what the prompt asks. One program per task. Do not create, rename or edit any other file.
2. Never edit: any file whose name starts with fp_, any .df file, any .bat file, start.p, run_sim.p, sim_day.p, anything in sim\ or schema\.
3. Never invent a table, field, sequence, program or function. Use only the names in this file or in the prompt. If you need something that is not listed, STOP and ask one short question.
4. If you are not 100% sure that a statement or function exists in ABL (OpenEdge 12.8), do not use it. Write the simplest alternative and add a comment: /* UNSURE: what */
5. Output the complete file and nothing else. No explanations, no extra files, no markdown inside the code.
6. Keep each program short (under 80 lines). No clever code. No classes, no temp-tables, no dynamic queries, no HTTP, no JSON, no file input or output, no OS-COMMAND, no SQL.
7. Never write ae_llm.p or anything that calls a web service. Reply only: Ask Claude for this one.
8. Never put a key, password or token in code. Secrets come from OS-GETENV only.
9. Never delete rows from ae_Warrant, ae_Proposal, ae_Exception or ae_AiLog. They are append-only. Only seed and test programs may delete ae_Charter rows.

## ABL basics (follow exactly)

- Every statement ends with a period. Never a semicolon.
- Blocks: DO: ... END.   FOR EACH ...: ... END.   IF ... THEN DO: ... END. then ELSE DO: ... END.
- Comments: /* like this */
- Strings use single quotes: 'text'. The escape character inside a string is the tilde (~), not backslash. Windows paths use backslash.
- The unknown value is ? . Test it with: IF x = ? THEN ...
- = is both assignment (x = 5.) and comparison (IF x = 5 THEN ...). There is no ==.
- Not equal is <> . Logic: AND OR NOT. Constants: TRUE FALSE.
- Comparing text with = ignores upper and lower case.
- No +=, no ++, no functions you define yourself, no return values. Write x = x + 1.
- Names are not case sensitive.
- Every DEFINE VARIABLE ends with NO-UNDO.
- Write numbers without thousands separators.

## Patterns that are correct

Parameters go at the top of the file, before anything else:

    DEFINE INPUT PARAMETER pBase AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAMETER oRuling AS CHARACTER NO-UNDO.
    DEFINE VARIABLE dRise AS DECIMAL NO-UNDO.

Types: CHARACTER INTEGER DECIMAL LOGICAL DATETIME-TZ.

Call a program (same order, same count, INPUT and OUTPUT as defined):

    RUN ae_steward.p (INPUT 'Strategy', INPUT 500, OUTPUT cRuling).

Find one row:

    FIND FIRST ae_Charter WHERE ae_Charter.ClauseID = 'PR-1' AND ae_Charter.Active = TRUE NO-LOCK NO-ERROR.
    IF AVAILABLE ae_Charter THEN ...

Loop over rows:

    FOR EACH ae_Charter WHERE ae_Charter.Version = 1 NO-LOCK:
        ...
    END.

Change or delete rows (needs EXCLUSIVE-LOCK):

    FOR EACH ae_Charter WHERE ae_Charter.Version = 1 EXCLUSIVE-LOCK:
        DELETE ae_Charter.
    END.

Create a row:

    CREATE ae_Warrant.
    ASSIGN ae_Warrant.WarrantID = NEXT-VALUE(ae_WarrantSeq)
           ae_Warrant.Ruling    = oRuling.

All or nothing:

    DO TRANSACTION ON ERROR UNDO, LEAVE:
        ...
    END.

Text to number, safely:

    dVal = DECIMAL(cText) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN ...

Other statements you may use:

- MESSAGE 'text' VIEW-AS ALERT-BOX.
- CASE cX: WHEN 'a' THEN ... OTHERWISE ... END CASE.
- DO i = 1 TO 10: ... END.   and   DO WHILE i < 10: ... END.
- OS-GETENV('NAME') returns ? when the variable is not set.
- PAUSE 5 NO-MESSAGE.
- ETIME(TRUE) resets a millisecond timer. ETIME reads it.
- RETURN.
- Text helpers: STRING() TRIM() LENGTH() SUBSTRING(text, start, length) INDEX() ENTRY(n, list) NUM-ENTRIES(list) LOOKUP(item, list) REPLACE(text, from, to) CAPS()
- Number helpers: ROUND(x, 2) ABSOLUTE(x) MAXIMUM(a, b) MINIMUM(a, b)
- Date and time: TODAY and NOW

## Project map

- New programs go in src\ and are named ae_<name>.p. The tests file is src\test_aegis.p.
- The session PROPATH already includes src and seed, so RUN ae_x.p works with no path.
- Style reference for layout and comments: src\fp_classify.p and src\test_all.p. Copy their style.

## Existing tables (read only unless the prompt says otherwise)

- fp_Customer: CustNum, Name, Phone, RegDate
- fp_Booking: BookingNum, CustNum, BookDate, PricePaid
- fp_Behaviour: BehaviourID, BehaviourCode, BookingBehaviour, CustNum, Description, RiskLevel, ActiveStatus  (spelled Behaviour)
- fp_Segment: SegName, DiscountPct, FloorPct, MinOrders, MinSpend
- fp_Profile: ProfileName, UnitName, Capacity, StartPrice, Drop1Price, Drop2Price, MarginalCost, WindowHours
- fp_Credit exists but is unused. Never touch it.

## New tables (created by the human)

(c = CHARACTER, i = INTEGER, d = DECIMAL, l = LOGICAL, dt = DATETIME-TZ)

- ae_Charter: ClauseID(c), Version(i), EngineScope(c), Regime(c), RuleText(c), LimitValue(d), Active(l), EffectiveFrom(dt)
- ae_Regime: RegimeID(i), Regime(c), DeclaredBy(c), Reason(c), DeclaredAt(dt), WarrantID(i)
- ae_Proposal: ProposalID(i), Engine(c), Subject(c), Kind(c), BaseValue(d), ProposedValue(d), FloorValue(d), ProposalText(c), TextSource(c), CreatedAt(dt)
- ae_Warrant: WarrantID(i), ProposalID(i), CharterVersion(i), Regime(c), Clauses(c), Ruling(c), ReasonCode(c), Authorizer(c), CustNum(i), SealedAt(dt), PrevFingerprint(c)
- ae_Exception: ExceptionID(i), WarrantID(i), ExcState(c), ReasonCode(c), HandledBy(c), HandledAt(dt)
- ae_AiLog: LogID(i), AiPoint(c), AiResult(c), Millis(i), LoggedAt(dt)
- Sequences: ae_ProposalSeq, ae_WarrantSeq, ae_ExceptionSeq, ae_RegimeSeq, ae_LogSeq

Allowed values: Regime is 'Normal' or 'Surge'. Ruling is 'Admit', 'Deny' or 'Override'. TextSource is 'AI', 'MOCK' or 'TEMPLATE'. ExcState is 'Open', 'Overridden' or 'Closed'. AiPoint is 'Advocate' or 'Concierge'. AiResult is 'accepted', 'rejected', 'failed' or 'fallback'.

## Vocabulary

- Charter: the rulebook. Regime: the market state, Normal or Surge, declared by a person.
- Steward: the rule checker. Warrant: the sealed record of one decision.
- Proposal: what an engine asks for. Advocate: the AI that writes proposal text.
- The AI never decides anything, and never writes a number that is not in the facts it was given.

## When the prompt is unclear

Ask ONE short question. Do not guess.
