# Aegis

Aegis is a governance layer for automated business decisions, built in Progress OpenEdge ABL (12.8, Windows).

Engines propose. The Steward judges each proposal against the Charter. The Seal records a Warrant that cannot be edited. The Advocate (an AI) explains the result in plain words, and every number it writes is checked against the record first.

Pricing (the `fp_` files) is the first engine. The same four steps are designed to govern any engine that writes a proposal.

First-time setup is in `README-setup.md`. This file is the overview.

## What is built, and what is not

| Item | Status |
|---|---|
| Steward, Seal and Warrant ledger | Built and tested |
| Replay of any decision, Exceptions, Concierge receipt | Built and tested |
| Advocate: number check and template fallback | Built and tested |
| Pricing engine and multi-asset simulator | Built and tested |
| Live model connection for the Advocate | Working in testing |
| Platform screens (launcher, Resolver desk, Watchtower, Charters, shared shifts, role assistants) | Concept. Browser mockup, scripted. Nothing is written to OpenEdge |
| Rules and AI app | Concept. Scripted |
| Precog, earned autonomy, decision taxonomy, Ombudsman AI | Roadmap. Not built |
| HR, demand and integration engines | Roadmap. Not built |

There are no customers and no revenue claims anywhere in this project.

## Quick start

Double-click these in the project folder. After any change, run `tests.bat` first and then `count.bat`. Both write test rows into the ledger (see the final clean rebuild below).

| File | What it does |
|---|---|
| `tests.bat` | Run this first. Runs the original engine tests |
| `count.bat` | Run this second. Runs the tests that count. A popup lists 12 numbered checks (1 to 12) with a PASS or FAIL for each, and a total |
| `demo.bat` | Opens the Live Simulator and feeds it a simulated day. Close any editor window first |
| `present.bat` | Opens the app launcher (the display suite below) |
| `workbench.bat` | Opens the OpenEdge editor in the project folder. Creates an empty database in `db\` if there is none |
| `rebuild.bat` | Loads the starting data into the database |
| `aegis.bat` | The single launcher behind the others. Actions: `demo`, `tests`, `rebuild`, `count` |

Only one OpenEdge session can use the database at a time.

In the editor, always start with `workbench.bat`, then run this once per editor session:

    RUN src\setup_path.p.

## Display suite (`sim\`)

Open these through `present.bat`, or open the files directly in a browser.

| Page | What it is |
|---|---|
| `aegis_hub.html` | The launcher. Also holds the Lock manager and passkey |
| `aegis_live.html` | The live display. Tabs: Live, Code, Scenes |
| `aegis_presentation.html` | The talk (9 slides), plus a Media tab with every clip and screenshot |
| `aegis_platform.html` | Concept business app. Switch person from the avatar menu. Each role has its own scripted assistant |
| `aegis_explained.html` | A one-page explanation for anyone. Runs as a looping, self-scrolling showcase |
| `aegis_rules.html` | Rules and AI app (scripted) |
| `aegis_config.js` | Settings. `AEGIS_OPEN` removes every lock. `AEGIS_ORG` optionally adds a company name to the footer |
| `feed.js` | Written by the simulation. Sets `window.FAIRPLAY` (12 fields) |

Keys in the Presentation: Right arrow, Space or click for the next step. Left arrow to go back. `S` shows presenter cues. `F` is fullscreen. `M` switches to the Media tab. `H` returns to the launcher.

The Explained page starts scrolling by itself about 4 seconds after it opens. The wheel, touch or keys pause it for 25 seconds. `P` or the Pause button stops it until you press Play. Add `#manual` to the address to start paused. To change the pace, edit `const DW=1` near the bottom of the file (below 1 is faster).

The platform screens work on the live feed if `feed.js` exists, and on scripted demo data if it does not. The header badge shows `LIVE` or `DEMO DATA`.

The lock is a soft lock using a token in the address. The passkey never goes in the repository.

## Naming

- `ae_` files and tables are the Aegis layer: the governance engines and their tables.
- `fp_` files and tables are the first pricing engine (FairPlay, legacy name).
- The database is still named `fairplay`, and the feed still uses `window.FAIRPLAY`. These stay as they are until after the competition, then they will be renamed.

## The AI key

The Advocate reads its key from the Windows environment variable `aegis_ai_key` (see `src\ae_llm.p`). If the key is missing, or the AI's answer fails the number check, Aegis falls back to fixed templates, so nothing depends on a network.

OpenEdge only sees an environment variable that existed when it started. After setting it, restart OpenEdge and the launcher.

To check the key is visible, type this into a new editor file such as `src\check_key.p` and run it. It shows only the length, so it is safe to run in front of others:

    DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.
    cKey = OS-GETENV('aegis_ai_key').
    IF cKey = ? OR cKey = '' THEN
        MESSAGE 'Key NOT found in OpenEdge environment.' VIEW-AS ALERT-BOX ERROR.
    ELSE
        MESSAGE 'Key found, ' + STRING(LENGTH(cKey)) + ' characters.' VIEW-AS ALERT-BOX INFO.

The assistants in the platform and rules screens are scripted. They do not call a model.

## Final clean rebuild

`tests.bat` and `count.bat` write test rows into the ledger (proposals, Warrants and one open exception). `rebuild.bat` does not clear them. Only deleting the `db` folder gives an empty ledger. So check first, then rebuild last, and do not run the tests again before the demo.

1. Check: run `tests.bat`, then `count.bat`. The count popup lists checks 1 to 12. Every line should say PASS.
2. Close every OpenEdge window, including the result popups.
3. Delete the `db` folder.
4. Double-click `workbench.bat`. It creates an empty database and says so.
5. In the editor, open Tools, then Data Administration, and load `schema\fairplay.df` (Admin, Load Data and Definitions, Data Definitions). Do not tick "Add new objects online". Menu names may differ slightly by version.
6. Close the editor.
7. Double-click `rebuild.bat`.
8. Double-click `demo.bat` and watch the Live Simulator run. Do not run `tests.bat` or `count.bat` after this step, or their rows will appear in the ledger.

## Submission copy

1. Finish the final clean rebuild above first, so the ledger is clean.
2. Make a copy of the project. Leave out the `db` folder if the rules ask for source only.
3. In the copy's `sim\aegis_config.js`, set `window.AEGIS_OPEN = true`. This removes every lock, so judges can open every page.
4. Leave the passkey out of the copy. Leave `AEGIS_ORG` commented out unless a company name has been agreed.
5. To check the copy, run `tests.bat` and then `count.bat` on a throwaway duplicate of it, not on the copy you ship, because the tests add rows to the ledger. A copy that includes `db` should be the one that was rebuilt and not tested afterwards.
6. Keep private documents (such as the venture positioning booklet) out of the copy.
7. Check that `media\` holds only your own captures, with no stock images.

## Known limitations

- The platform screens record nothing in OpenEdge. Approvals, vetoes, access requests and shifts exist only in the browser.
- Tested with the starting data and the simulated day only. No real operator data has been used.

## Documentation

- `README-setup.md`: first-run setup and the editor path.
- `CONVENTIONS.md`: build rules for adding programs.
- `docs\`: lessons and the platform architecture note.
- `AEGIS_BOOKLET.pdf`: the printed A4 booklet for judges.
