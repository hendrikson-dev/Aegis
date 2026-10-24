@echo off
setlocal
set "BASEDIR=%~dp0"
set "BASEDIR=%BASEDIR:~0,-1%"
cd /d "%BASEDIR%"

set "DBNAME=fairplay"
if not defined DLC set "DLC=C:\Progress\OpenEdge"
if not exist "%DLC%\bin\prowin.exe" echo OpenEdge not found. Set DLC. & pause & exit /b 1

if not exist "%BASEDIR%\db" mkdir "%BASEDIR%\db"

set "NEWDB="
if not exist "%BASEDIR%\db\%DBNAME%.db" (
    echo No database found. Creating an empty one...
    set "NEWDB=1"
    pushd "%BASEDIR%\db"
    > %DBNAME%.st echo b .
    >> %DBNAME%.st echo d "Schema Area":6,64 .
    "%DLC%\bin\_dbutil.exe" procopy "%DLC%\empty" %DBNAME% -relative
    popd
)

if not exist "%BASEDIR%\db\%DBNAME%.db" (
    echo Could not create the database. Open Proenv and run: prodb db\%DBNAME% empty
    pause
    exit /b 1
)

if defined NEWDB (
    echo.
    echo EMPTY database created. It has no tables yet.
    echo Next: load schema\fairplay.df. See README-setup.md.
    pause
)

set "FAIRPLAY_DIR=%BASEDIR%"
set "PROPATH=%BASEDIR%\src,%BASEDIR%\seed"
start "Aegis workbench" "%DLC%\bin\prowin.exe" -db "%BASEDIR%\db\%DBNAME%.db" -1
endlocal