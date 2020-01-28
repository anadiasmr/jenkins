@echo off
setlocal enabledelayedexpansion

Pushd %~dp0..\..\..

IF NOT EXIST %~dp0resources\mRemoteNG.zip (
	set local_path=%~dp0resources\mRemoteNG.zip
	set remote_path=https://github.com/mRemoteNG/mRemoteNG/releases/download/v1.77.1/mRemoteNG-Portable-1.77.1.27713.zip
	if not exist "!local_path!" echo Downloading '!local_path!' from '!remote_path!'
	if not exist "!local_path!" powershell -Command "Invoke-WebRequest !remote_path! -OutFile '!local_path!.tmp'"
	if not exist "!local_path!" powershell Move-Item -Path '!local_path!.tmp' -Destination '!local_path!'
)

IF NOT EXIST %~dp0bin (
	mkdir %~dp0bin
	powershell -Command "Expand-Archive '%~dp0resources\mRemoteNG.zip' '%~dp0bin'"
)
start %~dp0bin\mRemoteNG.exe /c:"%~dp0resources\confCons.xml"