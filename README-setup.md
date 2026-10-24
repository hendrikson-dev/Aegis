## Setup instructions

You need Progress OpenEdge (Developers Kit: Classroom Edition) installed. This was built and tested on OpenEdge 12.8, Windows.

Set your Groq API key in your Windows Environment Variables as aegis_ai_key. If the key is missing, the system will safely fall back to templates.

## First run (or after deleting the db folder)

1. Double-click `workbench.bat`. If `db\fairplay.db` does not exist, it creates an empty database and says so.
2. The new database has no tables. In the editor window, open Tools > Data Administration and load `schema\fairplay.df` (Admin > Load Data and Definitions > Data Definitions). Do not tick "Add new objects online". The menu names may differ slightly by version.
3. Close the editor, then double-click `rebuild.bat` to load the starting data.
4. Run the tests as in the Usage guide below.

Only one OpenEdge session can use the database at a time, so close other windows first.

## Running programs in the editor

1. Always open the editor with `workbench.bat`. It starts the editor in the project folder.
2. In each new editor session, run this once before running any program (this includes the `netlib` path required for the AI to connect over HTTPS):

   PROPATH = PROPATH + ',src,seed,' + OS-GETENV('DLC') + '\gui\netlib\OpenEdge.Net.pl'.

3. To check it worked:

   MESSAGE SEARCH('fp_price.p') VIEW-AS ALERT-BOX.

   It should show src\fp_price.p. If it shows ?, you opened the editor some other way.

The setting lasts only for that editor session, so repeat step 2 each time you reopen the editor. Do not type a full path. The relative folders only work because step 1 starts the editor in the project folder.

## Usage guide

- **Demo:** double-click `demo.bat`. The Live Simulator opens and the simulation feeds it. Close any editor window first.
- **Tests:** `tests.bat` runs the original engine tests. `count.bat` runs the tests that count and shows one scoreboard.
- **Presenting:** double-click `present.bat` to open the app launcher. Presentation is behind the passkey.
- **Editor:** open it only with `workbench.bat`, then run `RUN src\setup_path.p.` once per session.
- **Submission copy:** set `window.AEGIS_OPEN=true` in `sim\aegis_config.js`, then run `tests.bat` and `count.bat` from that clean copy.
- **To Start over:** delete the `db` folder and repeat steps 2 to 4.

**Naming Conventions:**
- `fp_` prefixes are legacy tables and engines (FairPlay/Provision).
- `ae_` prefixes are the new Aegis platform tables and governance engines.