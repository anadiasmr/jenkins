@echo off
setlocal enabledelayedexpansion
REM if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

call "%~dp0../env.cmd"
call "%~dp0../config.cmd"
Pushd %~dp0..\..\..

title Restarting Boot2docker (supports docker)

echo #
echo ##########################################################################
echo #########  Download missing Web Resources
echo ##########################################################################
echo #
IF EXIST "%rootPath%\Virtual Machines\Windows Host\Boot2docker (supports docker)\cache\web-resources.config" (
	for /F "usebackq delims=" %%a in ("%rootPath%\Virtual Machines\Windows Host\Boot2docker (supports docker)\cache\web-resources.config") do (
		for /F "tokens=1,2 delims=|" %%b in ("%%a") do (
			set local_path=%rootPath%\%%b
			set remote_path=%%c
			if not exist "!local_path!" echo Downloading '!local_path!' from '!remote_path!'
			if not exist "!local_path!" powershell -Command "Invoke-WebRequest !remote_path! -OutFile '!local_path!.tmp'"
			if not exist "!local_path!" powershell Move-Item -Path '!local_path!.tmp' -Destination '!local_path!'
		)
	)
)

REM Delete current VM
call "%~dp0/stop.bat" -s

echo #
echo ##########################################################################
echo #########  Restarting existing boot2docker VM
echo ##########################################################################
echo #
%boot2dockerCMD% start "%boot2dockerVMName%"
%boot2dockerCMD% ssh "%boot2dockerVMName%" "echo 'export http_proxy=%http_proxy%' >> ~/.profile && echo 'export https_proxy=%https_proxy%' >> ~/.profile && echo 'export no_proxy=%no_proxy%' >> ~/.profile"

echo #
echo ##########################################################################
echo #########  Recreating folder mounts between host (Windows) and guest (VM)
echo ##########################################################################
echo #
for /F "tokens=1,2,3,4,5,6,7,8,9 delims=," %%d in ("%foldersMapping%") do (
  for /F "tokens=1,2 delims=:" %%a in ("%%d") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-1' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%e") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-2' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%f") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-3' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%g") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-4' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%h") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-5' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%i") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-6' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%j") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-7' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%k") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-8' '%%b'"
  )
  for /F "tokens=1,2 delims=:" %%a in ("%%l") do (
    %boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo mkdir -p '%%b' && sudo mount -t vboxsf 'Share-9' '%%b'"
  )
)

echo #
echo ##########################################################################
echo #########  Enabling workspace bin in Virtual Machine
echo ##########################################################################
echo #
%boot2dockerCMD% ssh "%boot2dockerVMName%" "sudo chmod +x '/workspace/Virtual Machines/Common/bin/install-vm-bin.sh' && sudo '/workspace/Virtual Machines/Common/bin/install-vm-bin.sh' '/workspace/Virtual Machines/Common/bin' '/usr/bin'"

echo #
echo ##########################################################################
echo #########  Starting training resources
echo ##########################################################################
echo #
%boot2dockerCMD% ssh "%boot2dockerVMName%" "cd /workspace/Workspace/setup && docker-compose pull && docker-compose build --build-arg http_proxy=%http_proxy% --build-arg https_proxy=%https_proxy% --build-arg no_proxy=%no_proxy% && docker-compose up -d"

echo #
echo ##########################################################################
echo #########  Setting host (Windows) docker env variables
echo ##########################################################################
echo #
%boot2dockerCMD% env --shell cmd %boot2dockerVMName% > %rootPath%\tmp.txt
for /f "tokens=* usebackq" %%f in (%rootPath%\tmp.txt) do (
  %%f
  echo %%f
)
del %rootPath%\tmp.txt 

endlocal & (
  echo setx DOCKER_TLS_VERIFY %DOCKER_TLS_VERIFY%
  setx DOCKER_TLS_VERIFY %DOCKER_TLS_VERIFY%
  echo setx DOCKER_HOST %DOCKER_HOST%
  setx DOCKER_HOST %DOCKER_HOST%
  echo setx DOCKER_CERT_PATH %DOCKER_CERT_PATH%
  setx DOCKER_CERT_PATH %DOCKER_CERT_PATH%
)
echo #
echo ##########################################################################
echo #########  Instalation completed
echo #########  ssh credentials on 127.0.0.1:2222 = docker/tcuser
echo ##########################################################################
echo #
:END
PAUSE