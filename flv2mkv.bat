@ECHO OFF
for /r %%A in (*.flv) do (
    ffmpeg.exe  -i "%%A" -vcodec copy -acodec copy "%%~dpnA.mkv"
    if not errorlevel 1 if exist "%%~dpnA.mkv" del /q "%%A")