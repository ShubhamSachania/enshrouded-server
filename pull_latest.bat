@echo off
cd /d "%~dp0"
set "SAVES=C:\Users\Public\Documents\OnlineFix\1203620\Saves"

echo Pulling latest save from GitHub...
git pull origin main

if exist "world0.ksd" (
    echo Applying world save to game...
    copy /y "world0.ksd" "%SAVES%\"
) else (
    echo No world0.ksd found in this folder. Skipping copy.
)

echo Done!
pause
