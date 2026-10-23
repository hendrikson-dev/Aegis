# Aegis Platform: Build Blueprint (v3)

Updated Oct 21, 2026. The platform is the product. The engines are inputs to it.

This is the plan to build from and refer back to: names, principles, the Charter, the data model, the programs, the AI rules, the day-by-day build and the tests. Aegis is the platform. The engines are inputs to it.

## Names

One name per part. In code, tables and the README, use the plain name first. Use the brand name on slides. A stranger should be able to guess the job from the name.

| Brand name | Plain name | Job | Code prefix |
| --- | --- | --- | --- |
| Aegis | The platform | Checks every proposal against the rulebook and records the outcome | ae\_ |
| Charter | The rulebook | Limits that people write and own | ae\_Charter |
| Regime | The market state | Normal or Surge, declared by a person | ae\_Regime |
| Steward | The rule checker | Admits or denies a proposal; plain ABL, no AI | ae\_steward.p |
| Warrant | The sealed record | One decision, with its rule, its inputs and who authorized it | ae\_Warrant |
| Ledger | The record tables | Where Warrants live in OpenEdge | ae\_ tables |
| Provision, Strategy, Demand, HR | The engines | Calculate; they never act | fp\_ (existing), ae\_ (new) |
| Advocate | The AI proposer | Turns one engine’s numbers into a written proposal for its department | ae\_advocate.p |
| Concierge | The customer explainer | Shows a customer their Warrant in plain words | ae\_concierge.p |

**Are names strong?** Yes, when each name tells the job and is used the same way everywhere. They weaken when a judge has to decode them. Keep the engine names plain (they already are). Keep the one friendly name, Concierge, for the customer-facing screen only.

**Steward or Governor Bench?** Keep Steward. A bench suggests a court passing judgement, and Governor already meant something else earlier in your plan.

**FairPlay** lives on as the Provision Engine. Its existing tables and programs keep the fp\_ prefix. Everything new uses ae\_.

## Principles

Seven rules that every part of Aegis follows. Each one answers a question a judge is likely to ask.

1. **AI speaks at the edges. Rules decide in the middle.** AI writes proposals and explanations. It never decides, calculates a price or changes a record.
2. **Bounds, not values.** The Charter sets limits. Engines optimise inside them. The Steward checks the limits. This is how the business adapts without breaking its own rules.
3. **Context is an input.** The market regime and the customer’s booking context are stored with each Warrant. Same inputs, same ruling, so a decision can be replayed.
4. **People change the rules. The system never does.** A regime declaration or a Charter change is a person’s act, and it is recorded as a Warrant.
5. **Every outcome is recorded.** A denial is a Warrant. An override is a second Warrant that names the person who signed it.
6. **Show the rule, in neutral words.** Every receipt names the rule applied and the reason. No labels for customers, no apologies as a feature, no hidden score.
7. **Say only what is built.** Anything scripted, stubbed or planned is labelled that way in the README and on the slides.

## Architecture at a glance

&#91;embedded content: Aegis architecture · 3 layers, 11 parts\]

Engines and their Advocate only propose. The Steward checks each proposal against the Charter and the regime, and the Ledger seals the outcome. Every screen shows only what a Warrant says.

## One decision, step by step

Every path ends in a sealed Warrant. If any step before the seal fails, nothing is saved and nothing is shown as decided.

1. **Engine calculates** from OpenEdge data. Example: the scripted Strategy proposer asks for a price rise of 40%.
2. **Advocate writes the proposal text.** A check confirms every number in the text matches the engine’s output. If not, the text is rejected and a plain template built from the record is used.
3. **Steward reads the rules.** It loads the active Charter version and the current regime.
4. **Steward judges.** It checks each clause that applies and returns Admit or Deny. Each ruling names the clause behind it.
5. **Seal.** In one transaction, the proposal and its Warrant are written. A denial also opens an exception.
6. **Exception.** A denied proposal waits for a person. Either a manager overrides it with a reason code (Data Error, Strategic Override or Charter Error), which seals a second Warrant naming the manager; or the Owner declares a new regime, which seals its own Warrant, and the proposal is submitted again.
7. **Projection.** The affected person sees the Warrant. For a customer, that is the Audit view.
8. **Replay.** Aegis runs the Steward again on the stored proposal, Charter version and regime. The ruling should match.

**Stretch, not in the build:** an override cap, for example three overrides in 30 days escalates to the Owner.

## The Charter

The Charter is a list of bounds, and a bound can depend on the regime. That is how Aegis adapts without becoming arbitrary: the same inputs always get the same ruling, and the inputs include the market state.

**Example.** A competitor closes and demand rises 300%. The Strategy proposer asks for a price rise of 40%. In the Normal regime the cap is 10%, so the Steward denies it and opens an exception. Either a manager overrides with a signature, or the Owner declares Surge (cap 40%) and the proposal is admitted. Both routes leave a Warrant. A routine Tuesday and a crisis get different rulings because the recorded regime differs, not because a rule was bent.

**Demo Charter, version 1**

| Clause | Applies to | Regime | Rule | Limit |
| --- | --- | --- | --- | --- |
| PR-1 | Strategy | Normal | A single price change may not raise a price by more than | 10% |
| PR-2 | Strategy | Surge | Same rule | 40% |
| PR-3 | Strategy | Any | A price may not go below the floor in the engine profile | The profile’s floor |
| LI-1 | Provision | Any | Every price drop inside the window produces a recorded decision for each affected booking, even when the decision is “none owed” | Always |
| LI-2 | Provision | Any | Liability for one booking may not exceed the price difference that customer paid | 100% of the difference |
| TR-1 | All | Any | Every Warrant names the clause applied, and the affected customer can open it | Always |

**Provision stays adaptive.** Its weights (booking behaviour, spend history, time elapsed) are engine settings, not Charter clauses. The Charter only bounds what the engine may do. If two customers get different decisions, their receipts show different inputs or different rules. There is no hidden score.

**Regimes.** Normal and Surge are built. Crisis is a slide. A person declares a regime (the Owner role in the demo), gives a reason, and the declaration is sealed as its own Warrant.

**Versions.** Changing a clause creates a new version. Each Warrant stores the version it was judged under.

## Data model

Six new tables with the ae\_ prefix. The fp\_ tables stay as they are, and fp\_Credit stays unused. Add the new tables in the Data Dictionary, export a fresh full .df, then rebuild a database from it to prove the setup steps still work.

| Table | Fields (type) | Keys | Purpose |
| --- | --- | --- | --- |
| ae\_Charter | ClauseID (character), Version (integer), EngineScope (character), Regime (character), RuleText (character), LimitValue (decimal), Active (logical), EffectiveFrom (datetime-tz) | Unique: ClauseID + Version | The rulebook, versioned |
| ae\_Regime | RegimeID (integer), Regime (character), DeclaredBy (character), Reason (character), DeclaredAt (datetime-tz), WarrantID (integer) | Unique: RegimeID | Regime declarations; the latest is current |
| ae\_Proposal | ProposalID (integer), Engine (character), Subject (character), Kind (character), BaseValue (decimal), ProposedValue (decimal), ProposalText (character), TextSource (character: AI or template), CreatedAt (datetime-tz) | Unique: ProposalID | What an engine asked for, with its text |
| ae\_Warrant | WarrantID (integer), ProposalID (integer), CharterVersion (integer), Regime (character), Clauses (character), Ruling (character: Admit, Deny or Override), ReasonCode (character), Authorizer (character), CustNum (integer, optional), SealedAt (datetime-tz), PrevFingerprint (character, stretch) | Unique: WarrantID; indexes on ProposalID and CustNum | The sealed decision |
| ae\_Exception | ExceptionID (integer), WarrantID (integer), Status (character: Open, Overridden or Closed), ReasonCode (character), HandledBy (character), HandledAt (datetime-tz) | Unique: ExceptionID | Denied proposals waiting for a person |
| ae\_AiLog | LogID (integer), Point (character: Advocate or Concierge), Result (character: accepted, rejected, failed or fallback), Millis (integer), At (datetime-tz) | Unique: LogID | One row per AI call, with no keys and no secrets |

**Rules**

- IDs come from database sequences (look up NEXT-VALUE), taken inside the same transaction as the write.
- The programs only add rows to ae\_Warrant. They never update or delete one.
- Nothing in these tables holds a secret.

## Program map

New programs go in src with the ae\_ prefix, beside the existing fp\_ programs. Each takes INPUT and OUTPUT parameters (look up DEFINE INPUT PARAMETER) so each can be tested alone. Test numbers refer to the build plan.

| Program | Job | In → Out | Test |
| --- | --- | --- | --- |
| ae\_charter\_seed.p | Loads Charter v1 and the Normal regime | none → rows | Clause count is 6 |
| ae\_steward.p | Judges one proposal | engine, kind, base, proposed → ruling, clauses, reason | T1 to T4 |
| ae\_seal.p | Writes the proposal and Warrant (and an exception on denial) in one transaction | proposal, ruling → WarrantID | T5, T11 |
| ae\_declare.p | The Owner declares a regime and seals it | regime, person, reason → WarrantID | T4 |
| ae\_override.p (stretch) | A manager overrides an exception with a reason code | exception, person, code → WarrantID | T12 |
| ae\_scripted\_strategy.p | Scripted proposer standing in for the Strategy Engine (labelled a stub) | tick → proposal | Used in the demo |
| ae\_check\_numbers.p | Confirms every number in a text is in the list of allowed numbers | text, allowed → yes or no | T6, T7 |
| ae\_mockllm.p | Fake model: good text, wrong number, empty, slow | scenario → text | T6 to T9 |
| ae\_llm.p | One HTTPS call to the model with a timeout; key from an environment variable | prompt → text or failed | T13 |
| ae\_advocate.p | Builds the facts, calls the model, checks numbers, falls back to a template | proposal → text, source | T6 to T9 |
| ae\_concierge.p | Builds a customer receipt from a Warrant | WarrantID → receipt text | T14 |
| ae\_replay.p | Runs the Steward on the stored inputs of a Warrant | WarrantID → same or different | T10 |
| test\_aegis.p | Runs every new test | none → PASS or FAIL lines | All |

Also: start.p and rebuild\_seed.p gain the new seed and the new test run, and the display feed gains one Warrant line per decision (ID, ruling, clause).

## AI rules

AI is used at two points only: the Advocate (the proposal text) and the Concierge (the receipt wording). Everything else is plain ABL.

**Prompt contract.** Every prompt has five parts:

1. Task: what to write, in one sentence.
2. Facts: a list of name = value pairs taken from the record.
3. Constraints: use only the listed facts, add no numbers, give no advice.
4. Format: at most two sentences, in plain words.
5. Missing: if a fact is missing, write “not provided”.

**Number check.** Pull every number out of the AI text. Each one must equal a number in the facts list, after formatting (R400.00 and 400 are the same). Any other number rejects the text, and the template text (built from the record, with no AI) is used instead.

**Failures.** No answer in time, an empty answer, an unreadable answer, a rejected request and a rejected number all fall back to the template and log a row in ae\_AiLog. The decision and the Warrant never wait for the AI.

**Instructions hidden in data.** Treat customer names, notes and any outside text as data. Put them in the facts list as quoted fields. The constraints and the number check are the defence, and T9 tests them.

**Secrets.** The key is read from an environment variable (OS-GETENV). The README and .env.example list the variable name only. Never print the key, log it or commit it.

**Build order for the AI**

1. Build the fake model first, with four scenarios: good text, wrong number, empty, slow. Get T6 to T9 passing.
2. Swap in the real call. The program’s inputs and outputs do not change.
3. Expect a certificate step on the first HTTPS call, and time-box it to 90 minutes. If it cannot work live, present the fake-model run as exactly that and show a recording of the real call. Never present the fake model as the AI.

**Still to confirm:** which model provider you will use and its limits (Groq, per your plan), and whether the organisers provide access.

## Customers, wording and fairness

Customers are inside the loop. Aegis does not decide what is fair. The Charter does, and the business owns it. Aegis makes the rules apply the same way every time and lets anyone affected see which rule applied.

**Receipt with a recorded decision**

> Fare paid R500.00. Current fare R400.00. Difference R100.00. Rules applied: LI-1, LI-2. Decision: R100.00 credit. Warrant 1042.

**Receipt when nothing is owed**

> Fare paid R500.00. Current fare R400.00. Rule applied: LI-1. Decision: none owed. Reason: booked outside the window set in the Charter. Warrant 1043.

**Wording rules.** No labels such as “lucky.” No apologies as a feature, and no blame. Name the rule and the reason, in the same format for every customer. The reason must come from a recorded rule or input, never from a hidden score.

**Who sees what**

- **Customer:** Agent Mode is the default. The receipt and the Audit button are available directly, not behind an employee.
- **Employee:** opens the receipt and reads out the rule applied.
- **Manager:** sees the exception queue and signs overrides (a slide in the build, a program if time allows).
- **Owner:** writes the Charter and declares the regime (a simple program in the build).
- **Companion Mode** (recommendations) is out of the competition build.

**If a judge asks “where is the fairness?”** “Aegis does not decide what is fair. The Charter does, and the business owns it. Aegis makes sure the rules are applied the same way every time, and that anyone affected can see which rule applied. Here is a price rise it denied, and here is the record. Here is the same rise admitted after the Owner declared Surge.”

**What Aegis does not claim:** that a business using it is fair, that its Charter is fair, or legal compliance.

**What it can show once built and tested:** the same inputs get the same ruling, every decision names its rule, denials are recorded, affected people can see the reason, and rule changes are attributable to a person.

**Policy is configurable.** The demo Charter protects both the margin (PR-1 to PR-3) and the customer (LI-1, LI-2, TR-1). Another business could set other limits, and each Warrant records which ones ran. Paying a smaller upgrade instead of cash owed is a policy a business must state to its customers. It is not part of the demo.

## What OpenEdge does here, and claims to avoid

This section describes only this system. It makes no comparison with other products.

- **One transaction around the seal.** A Warrant is fully written or not written at all. T5 shows it.
- **Record locking.** The Steward holds the record it is judging while it seals, so two actors cannot seal conflicting results. Claim this only if you test it with two sessions.
- **Typed fields.** The schema rejects a value of the wrong type. The number check separately rejects an invented number of the right type. These are two different defences.
- **Unique indexes.** A Warrant ID cannot be duplicated.
- **One source of truth.** The engine, the Steward, the Ledger and the Concierge all read the same database.

**Claims to fix before anyone reads the README**

| Instead of | Say |
| --- | --- |
| immutable, unbreakable, permanently recorded | append-only by design, because the programs only add Warrants |
| guarantees it will never breach the Charter | never admits a proposal that breaks a Charter clause |
| guarantees rule-breaking needs human authorization | inside Aegis, a denied proposal needs a named person to override it |
| milliseconds | remove it; model calls take seconds |
| legal compliance, legal liability | the Charter’s rules as the business wrote them; not legal advice |
| plugs into existing ERP or POS systems | designed as a sidecar; the demo feeds it simulated orders |
| nothing acts unsigned | in the demo, nothing is shown as decided until it is sealed |
| the customer never sees a half-finished record | the seal is one transaction, so a Warrant is whole or absent |
| any comparison with other technology stacks | remove it |

## Scope map

Say exactly this in the README: “Provision is built and tested. Strategy is a scripted proposer. Demand and HR are described, not built.”

| Status | Items |
| --- | --- |
| Built | Provision Engine (formerly FairPlay) with segments and booking behaviour, the simulation, the live display, the schema, the launcher, 7 tests and the break-it tests |
| Build for the demo | Charter and regime; the Steward; Warrant sealing in one transaction; the scripted Strategy proposer (labelled a stub); the Owner declaring Surge; the Advocate with the number check, the fake model and the real call; the Concierge receipt; replay |
| Stub or slide only | Demand Engine, HR Engine, manager and owner screens, Gap report, override cap, Companion Mode, overbooking, fleet consolidation, partner routing, the full Resolution Matrix, lifetime-value weighting beyond the existing segments |
| Vision | Sidecar integration with existing systems, other businesses, exposing the Steward as a service for AI tools |

## Build plan by day, gates, tests and cut order

The code freeze is Tue Oct 27. Submit that evening if you can, and by 2:00 PM on Wed Oct 28 at the latest.

| Day | Build | Done when |
| --- | --- | --- |
| Wed Oct 21 (today) | On paper: Charter clauses, regime, Warrant fields. Add the six tables, export a fresh .df, rebuild a database from it | A fresh rebuild works with the new tables |
| Thu Oct 22 | ae\_charter\_seed.p and ae\_steward.p | T1 to T4 pass |
| Fri Oct 23 | ae\_seal.p in one transaction, ae\_declare.p, the scripted proposer feeding the simulation | T5 and T11 pass; the feed shows Warrants |
| Sat Oct 24 | ae\_mockllm.p, ae\_check\_numbers.p, ae\_advocate.p with the template fallback | T6 to T9 pass. **Gate A:** the whole chain works on the fake model |
| Sun Oct 25 | ae\_llm.p, the real call, the AI log | T13 passes with a key. **Gate B:** what is not working stays out |
| Mon Oct 26 | ae\_concierge.p receipt on the display, ae\_replay.p, fresh-machine test, README draft, three full runs | T10 and T14 pass; the README works from a clean copy |
| Tue Oct 27 | Freeze. Final tests, repo scan, push, submit | Everything passes from a clean copy |
| Wed Oct 28 | Buffer before 2:00 PM, backup video, rehearsal | Submission confirmed |
| Thu Oct 29 | Presentation |  |

**Tests**

| Test | What it proves |
| --- | --- |
| T1 | A price rise within the cap is admitted and sealed |
| T2 | A rise over the cap in Normal is denied and recorded |
| T3 | A price below the floor is denied |
| T4 | Surge admits what Normal denied |
| T5 | A forced failure mid-write saves nothing (a test that is meant to fail the write) |
| T6 | AI text with correct numbers is accepted |
| T7 | AI text with a wrong number is rejected |
| T8 | An empty, slow or failed model call falls back to the template |
| T9 | An instruction hidden in input data is ignored |
| T10 | Replay gives the same ruling |
| T11 | A denial is recorded as a Warrant |
| T12 | Stretch: an override seals a second Warrant naming the manager |
| T13 | The real model call returns text (manual, needs the key) |
| T14 | The receipt names the rule applied |

The existing test\_all.p stays at 7 PASS and the break-it tests still pass.

**Cut order if time runs short:** Audit screen styling, then replay on the display (keep ae\_replay.p), then the override program, and only as a last resort the real model call (then show a recording, labelled as one).

**Never cut:** the Steward’s Admit and Deny with a recorded Warrant, the one-transaction seal with T5, the number check with its fallback, the README and the repo scan.

## README and judging

The jury scores Impact, Innovation, and Quality and execution. Use those three words as headings in the presentation.

| Criterion | How the build answers it | Show |
| --- | --- | --- |
| Impact | A real problem: businesses cannot prove, or safely adjust, the decisions their engines make. Aegis records each decision with its rule, so a business can adapt quickly and still show what happened | A price rise denied, then admitted after a Surge declaration |
| Innovation | AI is caged: it writes and explains, and OpenEdge decides and records. Rules are bounds that depend on a regime a person declares. Every decision can be replayed | The invented-number rejection and the replay |
| Quality and execution | A working OpenEdge integration, 14 tests including ones meant to fail, a one-click launcher, and a README that works from a clean copy | tests.bat, the failed write, the clean-copy run |

**README outline** (the four required headings come first)

1. **Project overview:** the problem, who it is for, what Aegis does, that it runs as a shadow run on simulated data, and the scope line from the scope map.
2. **Technical approach:** the layers, the decision flow, the Charter and regime, the data model, the AI rules, and why the model never decides.
3. **Setup instructions:** the OpenEdge version, create an empty database, load the .df, run rebuild.bat and tests.bat, and the name of the environment variable for the key.
4. **Usage guide:** demo.bat, what to expect on screen, how to run the tests, and how to declare a regime.
5. **How this was built:** “I’m a first-time coder. I built this with Claude as my coach, and I tested, changed and own every decision.”
6. **Limitations and next steps:** taken from the scope map.

**Six demonstrations, 30 to 60 seconds each**

1. **Admit and seal:** a normal proposal becomes a Warrant, and the customer opens the receipt.
2. **Deny:** a +40% rise in Normal is denied and recorded, with the clause named.
3. **Adapt:** the Owner declares Surge, and the same proposal is admitted.
4. **Invented number:** a fake model answer with a wrong figure is rejected and the template appears.
5. **Failed write:** a forced error leaves nothing saved.
6. **Replay:** the same inputs give the same ruling.

**Order for 3 to 5 minutes:** the problem (30 seconds), demonstrations 1 to 3 live (100 seconds), demonstrations 4 and 5 (60 seconds), the architecture slide with stubs labelled (45 seconds), and an honest close with the disclosure sentence (30 seconds). Keep a backup video of the full run.

## Open decisions for you

1. Confirm the names: Aegis for the platform, Warrant for the record, and Steward kept instead of Governor Bench.
2. Confirm the demo limits: 10% in Normal and 40% in Surge. Change them if you prefer other numbers.
3. Confirm who declares the regime in the demo: the Owner role, through a small program.
4. Decide whether the manager override (T12) is attempted. I recommend only after Gate B.
5. Confirm the model provider and its limits, and whether the organisers provide access.
6. Decide whether the fingerprint chain (PrevFingerprint) is attempted. I recommend no, unless everything else is done. If it is not built, say append-only by design, not tamper-evident.
7. Confirm that the scripted Strategy proposer is acceptable, labelled as a stub.
