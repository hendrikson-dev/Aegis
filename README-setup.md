## Setup instructions

You need Progress OpenEdge (Developers Kit: Classroom Edition) installed. This was built and tested on OpenEdge <ADD YOUR VERSION>, Windows.

## First run (or after deleting the db folder)

1. Double-click `workbench.bat`. If `db\fairplay.db` does not exist, it creates an empty database and says so.
2. The new database has no tables. In the editor window, open Tools > Data Administration and load `schema\fairplay.df` (Admin > Load Data and Definitions > Data Definitions). Do not tick "Add new objects online". The menu names may differ slightly by version.
3. Close the editor, then double-click `rebuild.bat` to load the starting data.
4. Run the tests as in the Usage guide below.

Only one OpenEdge session can use the database at a time, so close other windows first.

## Running programs in the editor

1. Always open the editor with `workbench.bat`. It starts the editor in the project folder.
2. In each new editor session, run this once before running any program:

   PROPATH = PROPATH + ',src,seed'.

3. To check it worked:

   MESSAGE SEARCH('fp_price.p') VIEW-AS ALERT-BOX.

   It should show src\fp_price.p. If it shows ?, you opened the editor some other way.

The setting lasts only for that editor session, so repeat step 2 each time you reopen the editor. Do not type a full path. The relative folders only work because step 1 starts the editor in the project folder.

## Usage guide

- **Demo (shadow run):** double-click `demo.bat`. The display page opens, and the simulator feeds it simulated orders. FairPlay reports what it would hold and what it would owe.
- **Tests:** double-click `tests.bat`.
- **Start over:** delete the `db` folder and repeat steps 2 to 4.
