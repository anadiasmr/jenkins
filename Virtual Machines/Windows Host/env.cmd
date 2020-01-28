Pushd %~dp0..\..

for %%I in (.) do set rootDirName=%%~nxI
SET rootPath=%cd%
SET rootPathReverse=%rootPath:\=/%

SET PATH=%SystemRoot%\System32\Wbem;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;%~dp0bin\

SET vBoxManageCMD="%VBOX_MSI_INSTALL_PATH%VBoxManage.exe"

SET boot2dockerCMD="%~dp0Boot2docker (supports docker)\bin\docker-machine-0.16.2.exe" --storage-path="%rootPath%\.virtualbox\boot2docker"
SET boot2dockerVMName=boot2docker-%rootDirName%