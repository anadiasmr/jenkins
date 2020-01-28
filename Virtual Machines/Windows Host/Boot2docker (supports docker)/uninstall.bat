@echo off
setlocal

if "%~1"=="-s" GOTO UNINSTALL

title Unistall Boot2Docker Machine

:PROMPT
echo #
echo ##########################################################################
echo #########  Confirmation
echo ##########################################################################
echo #
SET /P AREYOUSURE=You are going to remove this Virtual Machine. Are you sure (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO END

call "%~dp0../env.cmd"
call "%~dp0../config.cmd"
Pushd %~dp0..\..\..

:UNINSTALL
REM Delete current boot2docker VM
if exist "%~dp0..\..\..\.virtualbox\boot2docker\" (
  echo #
  echo ##########################################################################
  echo #########  Stopping and removing boot2docker VM
  echo ##########################################################################
  echo #
  %boot2dockerCMD% stop "%boot2dockerVMName%"
  %boot2dockerCMD% rm -f "%boot2dockerVMName%"
  rmdir "%~dp0..\..\..\.virtualbox\boot2docker" /q /s
)
:END
echo #
echo ##########################################################################
echo #########  Uninstall executed!
echo ##########################################################################
echo #

if not "%~1"=="-s" PAUSE