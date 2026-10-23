@echo off
setlocal

set "ACTION=%~1"
if "%ACTION%"=="" set "ACTION=demo"

set "BASEDIR=%~dp0"
set "BASEDIR=%BASEDIR:~0,-1%"
cd /d "%BASEDIR%"

if not defined DLC if exist "C:\Progress\OpenEdge\bin\prowin.exe" set "DLC=C:\Progress\OpenEdge"
if not defined DLC goto :noopenedge
if not exist "%DLC%\bin\prowin.exe" goto :noopenedge
if not exist "%BASEDIR%\db\fairplay.db" goto :nodb

if /i "%ACTION%"=="demo" start "" "%BASEDIR%\sim\fairplay_display.html"

set "FAIRPLAY_ACTION=%ACTION%"
set "FAIRPLAY_DIR=%BASEDIR%"
set "FAIRPLAY_ACTION=%ACTION%"
start "FairPlay" "%DLC%\bin\prowin.exe" -p "%BASEDIR%\src\start.p" -db "%BASEDIR%\db\fairplay.db" -1
echo Folder: %BASEDIR%
echo Action: %ACTION%
pause
goto :end

:noopenedge
echo OpenEdge was not found. Set DLC to your OpenEdge folder.
pause
exit /b 1

:nodb
echo The database does not exist yet. Follow the README setup steps.
pause
exit /b 1

:end
endlocal