@echo off
cd /d "%~dp0"
set "SAVES=C:\Users\Public\Documents\OnlineFix\1203620\Saves"

echo [1/4] Pulling latest save from GitHub...
git pull origin main

echo [2/4] Applying world save...
if exist "world0.ksd" (
    copy /y "world0.ksd" "%SAVES%\"
) else (
    echo No world0.ksd found in this folder. Skipping copy.
)

echo [3/4] Launching Enshrouded...
start "" "..\enshrouded.exe"
powershell -Command "while (!(Get-Process enshrouded -ea 0)) { sleep 1 }; Wait-Process -Name enshrouded"

echo [4/4] Syncing world back to GitHub...
if exist "%SAVES%\world0.ksd" (
    copy /y "%SAVES%\world0.ksd" .
    git add world0.ksd
    git commit -m "Auto-save: %date% %time%"
    git push origin main
) else (
    echo No world save found in "%SAVES%". Skipping sync.
)

echo Done! Everything is synced.