@echo off
title Enshrouded Push Current World to GitHub

:: ==========================================
:: SETTINGS
:: ==========================================
set "WorldName=world0"
set "WorldFolder=C:\Users\Public\Documents\OnlineFix\1203620\Saves"
:: ==========================================

set "GitFolder=%~dp0"
cd /d "%GitFolder%"

echo [1/2] Copying "%WorldName%" files from game save to this folder...
if exist "%WorldFolder%\%WorldName%.ksd" copy /Y "%WorldFolder%\%WorldName%.ksd" "%GitFolder%"
if exist "%WorldFolder%\%WorldName%.ksd.backup" copy /Y "%WorldFolder%\%WorldName%.ksd.backup" "%GitFolder%"

echo [2/2] Uploading to GitHub...
if exist ".git" (
    git add .
    git commit -m "Manual auto-save world: %WorldName%"
    git push origin main
) else (
    echo Note: .git repository not detected. File copied locally to "%GitFolder%".
)

echo Done!
pause
