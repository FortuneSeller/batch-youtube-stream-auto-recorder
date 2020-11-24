@foo.bar >NUL 2>&1
@ECHO OFF
@setlocal enableextensions ENABLEDELAYEDEXPANSION
@pushd %~dp0
chcp 65001


REM creats the subfolders with a custome streamRec.bat for each one

for /f "tokens=2 delims=:" %%i in ('type Channel.txt^|find "https://"') do (

set "id=%%i"
set "id=!id:~26!"

FOR /F "delims==" %%A IN ('youtube-dl.exe --playlist-end 1 --no-warnings --get-filename -o "%%(uploader)s" "https://www.youtube.com/channel/!id!"') DO SET channelname=%%A

set channelname=!channelname: =_!
mkdir "!channelname!"
pushd %~dp0"!channelname!"
set name=%~dp0!channelname!\!channelname!

(
echo @foo.bar >NUL 2>&1
echo @ECHO OFF
echo @setlocal enableextensions
echo @pushd %%~dp0
echo :again
echo streamlink "https://www.youtube.com/embed/live_stream?channel=!id!" best --retry-streams 15 --hls-live-edge 99999 --hls-segment-threads 10 -o "!name!_[%%MYDATE%%].flv"
echo ffmpeg  -y -i "!name!_[%%MYDATE%%].flv" -vcodec copy -acodec copy "!name!_[%%MYDATE%%].mp4"
echo if not errorlevel 1 if exist "!name!_[%%MYDATE%%].mp4" del /q "!name!_[%%MYDATE%%].flv"
echo timeout /t 300 /nobreak > NUL
echo goto again
echo EXIT
)>streamRec.bat
popd
)




REM creats the master command

dir /s /b streamRec.bat > master.txt
(for /f "delims=" %%i in (master.txt) do (
set "str=%%i"
set "str=!str:~0,-14!"
echo cd "!str!"
echo start "!str!" "%%i"
echo cd ..
))>master.bat

del master.txt
exit

