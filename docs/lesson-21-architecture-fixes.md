# Infrastructure and Path Fixes — The Journey

**Date:** Oct 18, 2026
**Status:** Solved. Project is now 100% portable and database rebuild is automated.

## The Problems We Faced

### 1. The Hardcoded Path Nightmare
Originally, the `PROPATH` in the code and the `cSimDir` in the simulation used absolute paths (`D:\Workspaces\...`). If a judge downloaded the repo, the code would instantly fail with Error 293 (`fp_classify.p not found`).

### 2. The OpenEdge Working Directory Trap
We tried switching to relative paths (`.\src`), but OpenEdge failed. We discovered that OpenEdge resolves relative paths based on the *session's working directory*, not the folder the file is in. If launched from a desktop shortcut, the working directory defaults to `C:\Windows\System32`, so it looked in the wrong place.

### 3. The `.df` Load Abort
When rebuilding the database from `fairplay.df`, the load aborted. We learned that a `.df` load fails if the database is not completely empty, and loading "online" leaves indexes inactive. 

### 4. The Missing Seed Data
We discovered that `fp_seed.p` (which creates the initial Segments and Customers) was missing from our restore order. Without it, `fp_classify.p` quietly defaults everyone to "New" and breaks the test logic.

### 5. The `-param` Batch File Bug
When passing the folder path via the `-param` startup parameter in the batch file, OpenEdge misread the arguments. It tried to open the folder path as a file, throwing a "Cannot open file. The file may be too large" error.

---

## The Solutions

### 1. The Launcher Kit (Environment Variables & `%~dp0`)
Instead of fighting OpenEdge's command line parser, we bypassed it entirely using Windows Environment Variables.

*   **`fairplay.bat`** gets its own physical location using `%~dp0`.
*   It sets `FAIRPLAY_DIR` and `FAIRPLAY_ACTION` as environment variables.
*   It launches `prowin.exe` and triggers **`start.p`**.
*   **`start.p`** reads the environment variables, dynamically builds the `PROPATH` (`cBase + "\src"`), and dispatches the correct action (`demo`, `tests`, or `rebuild`).

### 2. The True Database Rebuild Order
We corrected the seed order. On a fresh database (created via `prodb`), the exact sequence is:
1.  `fp_seed.p` *(Creates Segments and initial customers)*
2.  `seed_profile.p`
3.  `seed_day4.p`
4.  `reset_sim.p`
5.  `gen_data.p`
6.  `seed_demo.p`

This sequence is now automated inside **`rebuild_seed.p`**, which is triggered by `rebuild.bat`.

### 3. The Blank Editor is Success
When `prowin.exe` is launched with the `-p` (program) parameter, it runs the program and then exits. A blank editor after running `rebuild.bat` means the program executed successfully and closed, exactly like Developer Studio.

---

## The Final Architecture
*   **`rebuild.bat`** -> Sets up the database.
*   **`tests.bat`** -> Runs `test_all.p` and `test_break.p` for 7 PASS.
*   **`demo.bat`** -> Opens the browser and runs `run_sim.p`.

**Result:** The project can be zipped, copied to a folder with spaces in the name, and run on any machine without touching a single line of code. No paths are hardcoded.