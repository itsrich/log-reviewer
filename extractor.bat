@echo off
Setlocal EnableDelayedExpansion


set SOURCE=%1
for %%Z in (!SOURCE!) do (
	set SOURCE_PATH_UNC=%%~dpZ
	set SOURCE_NAME=%%~nxZ
)

pushd %SOURCE_PATH_UNC%
echo Extracting files...
set SOURCE_PATH=%cd%\

set DEST_PATH=%SOURCE_PATH%
set DEST_NAME=%SOURCE_NAME%

set SOURCE_PATH=%SOURCE_PATH:"=%
set SOURCE_NAME=%SOURCE_NAME:"=%
set DEST_PATH=%DEST_PATH:"=%
set DEST_NAME=%DEST_NAME:"=%

echo source path : %SOURCE_PATH%
echo source name : %SOURCE_NAME%
echo dest path   : %DEST_PATH%
echo dest name   : %DEST_NAME%


if exist %SOURCE_PATH%%SOURCE_NAME%\* goto notdir

move /Y "%SOURCE_PATH%%SOURCE_NAME%" "%TMP%\%SOURCE_NAME%" 
md "%DEST_PATH%%DEST_NAME%"
"%PROGRAMFILES%\7-zip\7z.exe" x -o"%DEST_PATH%%DEST_NAME%" -y "%TMP%\%SOURCE_NAME%"
del /Y "%TMP%\%SOURCE_NAME%" 
:notdir

for %%a in (zip rar jar z 7z bz2 gz gzip tgz tar) do (
	forfiles /P "%DEST_PATH%%DEST_NAME%" /S /M *.%%a /C "cmd /c if @isdir==FALSE "%~f0" @path @file"  > nul 2>&1
) 
echo ...finished
popd


 

