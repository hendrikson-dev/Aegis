## Setup instructions

For the overview, the display guide and the submission steps, see `README.md`. This file covers installing and running the project.

You need Progress OpenEdge (Developers Kit: Classroom Edition) installed. This was built and tested on OpenEdge 12.8, Windows.

Set your Groq API key in your Windows Environment Variables as aegis_ai_key. If the key is missing, the system will safely fall back to templates. OpenEdge only sees a variable that existed when it started, so restart OpenEdge and the launcher after setting it.

To check that OpenEdge can see the key, type this into a new editor file and run it. It shows only the length of the key:

    DEFINE VARIABLE cKey AS CHARACTER NO-UNDO.
    cKey = OS-GETENV('aegis_ai_key').
    IF cKey = ? OR cKey = '' THEN
        MESSAGE 'Key NOT found in OpenEdge environment.' VIEW-AS ALERT-BOX ERROR.
    ELSE
        MESSAGE 'Key found, ' + STRING(LENGTH(cKey)) + ' characters.' VIEW-AS ALERT-BOX INFO.

## First run (or after deleting the db folder)

1. Double-click `workbench.bat`. If `db\fairplay.db` does not exist, it creates an empty database and says so.
2. The new database has no tables. In the editor window, open Tools > Data Administration and load `schema\fairplay.df` (Admin > Load Data and Definitions > Data Definitions). Do not tick "Add new objects online". The menu names may differ slightly by version.
3. Close the editor, then double-click `rebuild.bat` to load the starting data.
4. Run `tests.bat` first, then `count.bat` (see the Usage guide below).

Only one OpenEdge session can use the database at a time, so close other windows first.

## Running programs in the editor

1. Always open the editor with `workbench.bat`. It starts the editor in the project folder.
2. In each new editor session, run this once before running any program (this includes the `netlib` path required for the AI to connect over HTTPS):

   PROPATH = PROPATH + ',src,seed,' + OS-GETENV('DLC') + '\gui\netlib\OpenEdge.Net.pl'.

   RUN src\setup_path.p.

3. To check it worked:

   MESSAGE SEARCH('fp_price.p') VIEW-AS ALERT-BOX.

   It should show src\fp_price.p. If it shows ?, you opened the editor some other way.

The setting lasts only for that editor session, so repeat step 2 each time you reopen the editor. Do not type a full path. The relative folders only work because step 1 starts the editor in the project folder.

## Usage guide

- **Tests:** run `tests.bat` first. It runs the original engine tests. Then run `count.bat`. It runs the tests that count and shows one scoreboard.
- **Demo:** double-click `demo.bat`. The Live Simulator opens and the simulation feeds it. Close any editor window first.
- **Presenting:** double-click `present.bat` to open the app launcher. Presentation is behind the passkey, unless `window.AEGIS_OPEN` is true in `sim\aegis_config.js`.
- **Editor:** open it only with `workbench.bat`, then run `RUN src\setup_path.p.` once per session.
- **Submission copy:** set `window.AEGIS_OPEN=true` in `sim\aegis_config.js`, leave the passkey out, then run `tests.bat` and then `count.bat` from that clean copy.
- **To start over:** delete the `db` folder and repeat the First run steps 2 to 4.

**Naming Conventions:**
- `fp_` prefixes are legacy tables and engines (FairPlay/Provision). The first pricing engine uses them.
- `ae_` prefixes are the new Aegis platform tables and governance engines.
- The database is still named `fairplay`, and the live feed still uses `window.FAIRPLAY`. These stay until after the competition.
