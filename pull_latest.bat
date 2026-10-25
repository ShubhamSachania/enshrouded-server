@echo off
title Enshrouded Pull Latest World

:: ==========================================
:: SETTINGS
:: ==========================================
set "WorldName=world0"
set "WorldFolder=C:\Users\Public\Documents\OnlineFix\1203620\Saves"
:: ==========================================

set "GitFolder=%~dp0"
cd /d "%GitFolder%"

if not exist "%WorldFolder%" mkdir "%WorldFolder%"

echo [1/2] Pulling latest saves from GitHub...
if exist ".git" (
    git pull origin main
) else (
    echo Note: .git repository not detected. Skipping git pull.
)

echo [2/2] Copying "%WorldName%" files to Enshrouded saves...
if exist "%GitFolder%%WorldName%\" (
    robocopy "%GitFolder%%WorldName%" "%WorldFolder%" "%WorldName%.*" /NDL /NFL /NJH /NJS /NP
) else (
    if exist "%GitFolder%%WorldName%.ksd" copy /Y "%GitFolder%%WorldName%.ksd" "%WorldFolder%\"
    if exist "%GitFolder%%WorldName%.ksd.backup" copy /Y "%GitFolder%%WorldName%.ksd.backup" "%WorldFolder%\"
)

echo Done! Latest world has been copied to your game folder.
pause
