@echo off
for /F %%x in ('dir /B/D 2x') do (
    if %%~xx == .png (
        if not exist 1x\%%x (
            echo Removing deleted file 1x\%%x from 2x\
            del 2x\%%x
        )
    )
)
for /F %%x in ('dir /B/D 1x') do (
    if %%~xx == .png (
        REM https://stackoverflow.com/questions/1687014/how-do-i-compare-timestamps-of-files-in-a-batch-script/58323817#58323817
        xcopy /LDY /-I 1x\%%x 2x\%%x | findstr /B /C:"1 " > nul 2>&1 && (
            echo Updating changed file 1x\%%x in 2x\
            magick 1x\%%x -filter point -resize 200%% 2x\%%x
        )
    )
)