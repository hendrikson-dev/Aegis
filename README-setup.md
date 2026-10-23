## Setup instructions

You need Progress OpenEdge (Developers Kit: Classroom Edition) installed. This was built and tested on OpenEdge <ADD YOUR VERSION>, Windows.

1. **Unzip the project anywhere** (for example `C:\Downloads\FairPlay`). Keep the folders together: `src`, `seed`, `sim`, `schema`.
2. **Create an empty database.** Open the **Proenv** window from the Start menu and run:
   ```
   cd /d "<your FairPlay folder>"
   mkdir db
   prodb db\fairplay empty
   ```
3. **Load the schema.** Open Data Administration, connect to `db\fairplay` in **single-user** mode, and load `schema\fairplay.df` (do not tick "Add new objects online").
4. **Load the starting data.** Close Data Administration, then double-click `rebuild.bat`. Click OK through the messages. It ends with "Rebuild finished."
5. **Check it.** Double-click `tests.bat`. Expect the tests to pass.

Only one OpenEdge session can use the database at a time (single-user mode), so close other sessions first.

## Usage guide

- **Demo (shadow run):** double-click `demo.bat`. The display page opens, and the simulator feeds it simulated orders. FairPlay reports what it would hold and what it would owe.
- **Tests:** double-click `tests.bat`.
- **Start over:** delete the `db` folder and repeat steps 2 to 4.
