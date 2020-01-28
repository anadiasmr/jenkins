@echo off
setlocal enabledelayedexpansion
REM if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

if "%~1"=="-s" GOTO SKIP-CONFIG

call "%~dp0../config.cmd"
call "%~dp0../env.cmd"
Pushd %~dp0..\..\..

title Stopping Boot2docker (supports docker)

:SKIP-CONFIG

echo #
echo ##########################################################################
echo #########  Stopping existing boot2docker VM
echo ##########################################################################
echo #
%boot2dockerCMD% stop "%boot2dockerVMName%"

if "%~1"=="-s" GOTO SKIP-PAUSE
PAUSE
:SKIP-PAUSE