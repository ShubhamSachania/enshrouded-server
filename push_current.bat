@echo off
cd /d "%~dp0"
set "SAVES=C:\Users\Public\Documents\OnlineFix\1203620\Saves"

if exist "%SAVES%\world0.ksd" (
    echo Copying world save from game...
    copy /y "%SAVES%\world0.ksd" .
    echo Uploading to GitHub...
    git add world0.ksd
    git commit -m "Manual save: %date% %time%"
    git push origin main
) else (
    echo No world save found in "%SAVES%". Skipping copy.
)

echo Done!
pause
