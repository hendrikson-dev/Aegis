Do these in order, and only when you’re done coding for the day.

1. Run test_all.p (once you reach Lesson 7), or your latest test. Back up only a state that works.

2. Export the schema, only if tables or fields changed today. In Data Administration, choose Admin, then Dump Data and Definitions, then Data Definitions (.df). Type the full path in the Output File box:

D:\Workspaces\OpenEdge-Projects\Fairplay_v1\schema\fairplay.df

3. Back up the database. Close the Procedure Editor and Developer Studio’s connection first. In Proenv, run these three commands. They stop the server, back up while nothing is running, and restart it:

proshut D:\Workspaces\OpenEdge-Projects\Fairplay_v1\db\fairplay -by
probkup D:\Workspaces\OpenEdge-Projects\Fairplay_v1\db\fairplay D:\Workspaces\OpenEdge-Projects\Fairplay_v1\backup\fairplay-2026-10-10.bak
proserve -S 3000 -db D:\Workspaces\OpenEdge-Projects\Fairplay_v1\db\fairplay

Change the date each day, so you keep every backup and don’t overwrite yesterday’s. Then check in File Explorer that the new .bak file exists, with today’s time and a size above zero.

4. Copy the project off the laptop. Your code lives inside Fairplay_v1, so this one command copies everything except the live database files:

robocopy D:\Workspaces\OpenEdge-Projects\Fairplay_v1 E:\FairPlayBackup\2026-10-10 /E /XD db

Replace E: with your USB drive or a cloud-synced folder. Robocopy prints a summary. Numbers below 8 in its exit code mean success.


5. Look at the result. Open the backup copy and check that src, seed, schema and the .bak file are there.

Optional: one file that does steps 3 and 4

Save this in Notepad as end_of_day.bat (choose All files, not .txt). Change E: to your drive, then run it from Proenv. I haven’t tested it, so do your first run with the manual commands open as a fallback:

@echo off
set /p D=Date for the backup name (for example 2026-10-10): 
set P=D:\Workspaces\OpenEdge-Projects\Fairplay_v1
call proshut %P%\db\fairplay -by
call probkup %P%\db\fairplay %P%\backup\fairplay-%D%.bak
call proserve -S 3000 -db %P%\db\fairplay
robocopy %P% E:\FairPlayBackup\%D% /E /XD db
pause
Once a week: prove a backup works

A backup you’ve never restored is only a hope. Restore one into a different scratch folder, so nothing live is touched:

mkdir D:\Scratch\restoretest
prorest D:\Scratch\restoretest\fairplay D:\Workspaces\OpenEdge-Projects\Fairplay_v1\backup\fairplay-2026-10-10.bak

Then connect to it and run your check. Never run prorest with your live database’s name, because it replaces what’s there.

When you’ve done a full routine once, tell me how it went, and send a screenshot if any step prints something unexpected.