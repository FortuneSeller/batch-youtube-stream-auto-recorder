@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM creats the subfolders with a custome streamRec.bat for each one

for /f "tokens=2 delims=:" %%i in ('type Channel.txt^|find "https://"') do (
set "str=%%i"
set "str=!str:~2!"

set "id=%%i"
set "id=!id:~26!"

mkdir !id!
cd !id!

(
echo @ECHO off
echo :again
echo SET MYDATE=20%%DATE:~8,4%%-%%DATE:~3,2%%-%%DATE:~0,2%%_%%time:~0,2%%-%%time:~3,2%%-%%%time:~6,2%%
echo streamlink !str!/live best --retry-streams 30 --player-passthrough=hls --hls-segment-threads 10 -o "%%MYDATE%%.flv"
echo timeout /t 300 /nobreak > NUL
echo goto again
echo EXIT
)>streamRec.bat
cd ..
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
