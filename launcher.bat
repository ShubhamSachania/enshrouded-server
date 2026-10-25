@echo off
title Enshrouded Sync ^& Play

:: ==========================================
:: SETTINGS
:: ==========================================
set "WorldName=world0"
set "WorldFolder=C:\Users\Public\Documents\OnlineFix\1203620\Saves"
set "GameFolder=%~dp0.."
set "GameExe=%GameFolder%\enshrouded.exe"
:: ==========================================

:: Lock the Git folder path to exactly where this .bat file is located
set "GitFolder=%~dp0"
cd /d "%GitFolder%"

:: Ensure the Enshrouded save folder exists
if not exist "%WorldFolder%" mkdir "%WorldFolder%"

:: 1. Pull latest saves from GitHub
echo [1/5] Pulling latest saves from GitHub...
if exist ".git" (
    git pull origin main
) else (
    echo Note: .git repository not detected. Skipping git pull.
)

:: 2. Copy the SPECIFIC world from Git to Enshrouded's local saves
if exist "%GitFolder%%WorldName%\" (
    echo [2/5] Copying world folder "%WorldName%" to Enshrouded...
    robocopy "%GitFolder%%WorldName%" "%WorldFolder%" "%WorldName%.*" /NDL /NFL /NJH /NJS /NP
) else (
    echo [2/5] Copying "%WorldName%" files to Enshrouded...
    if exist "%GitFolder%%WorldName%.ksd" copy /Y "%GitFolder%%WorldName%.ksd" "%WorldFolder%\"
    if exist "%GitFolder%%WorldName%.ksd.backup" copy /Y "%GitFolder%%WorldName%.ksd.backup" "%WorldFolder%\"
)

:: 3. Start Enshrouded and wait for you to close it
echo [3/5] Starting Enshrouded... (Script will wait here until you exit the game)
cd /d "%GameFolder%"
start "" "%GameExe%"
powershell -NoProfile -Command "for ($i=0; $i -lt 30; $i++) { if (Get-Process -Name 'enshrouded*' -ErrorAction SilentlyContinue) { break }; Start-Sleep 1 }; $p = Get-Process -Name 'enshrouded*' -ErrorAction SilentlyContinue; if ($p) { $p | Wait-Process }"
cd /d "%GitFolder%"

:: 4. You closed the game! Copy updated world back to this Git folder
echo [4/5] Game closed. Copying "%WorldName%" files back...
if exist "%WorldFolder%\%WorldName%.ksd" copy /Y "%WorldFolder%\%WorldName%.ksd" "%GitFolder%"
if exist "%WorldFolder%\%WorldName%.ksd.backup" copy /Y "%WorldFolder%\%WorldName%.ksd.backup" "%GitFolder%"

:: 5. Upload to GitHub
echo [5/5] Uploading to GitHub...
cd /d "%GitFolder%"
if exist ".git" (
    git add .
    git commit -m "Auto-save world: %WorldName%"
    git push origin main
) else (
    echo Note: .git repository not initialized yet. Changes saved locally in "%GitFolder%".
)

echo Done! Everything is synced.
pause
