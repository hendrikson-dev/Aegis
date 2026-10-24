@echo off
setlocal

set "ACTION=%~1"
if "%ACTION%"=="" set "ACTION=demo"

set "BASEDIR=%~dp0"
set "BASEDIR=%BASEDIR:~0,-1%"
cd /d "%BASEDIR%"

set "DBNAME=fairplay"
if not defined DLC set "DLC=C:\Progress\OpenEdge"
if not exist "%DLC%\bin\prowin.exe" goto :noopenedge
if not exist "%BASEDIR%\db\%DBNAME%.db" goto :nodb
if exist "%BASEDIR%\db\%DBNAME%.lk" goto :busy

if /i "%ACTION%"=="demo" start "" "%BASEDIR%\sim\aegis_live.html"

set "FAIRPLAY_DIR=%BASEDIR%"
set "FAIRPLAY_ACTION=%ACTION%"
start "Aegis" "%DLC%\bin\prowin.exe" -p "%BASEDIR%\src\start.p" -db "%BASEDIR%\db\%DBNAME%.db" -1
echo Folder: %BASEDIR%
echo Action: %ACTION%
pause
goto :end

:noopenedge
echo OpenEdge was not found. Set DLC to your OpenEdge folder.
pause
exit /b 1

:nodb
echo The database does not exist yet. Run workbench.bat first, then see README-setup.md.
pause
exit /b 1

:busy
echo The database is in use. Close any OpenEdge editor window first.
echo If nothing is open, delete db\%DBNAME%.lk and try again.
pause
exit /b 1

:end
endlocal