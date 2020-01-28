REM Ram memory amount used by the Virtual Machine (MB)
SET memory=8192

REM CPU cores used by the Virtual Machine
SET cpus=4

REM Disk amount used by the Virtual Machine (MB)
SET diskMB=10000

REM Proxy
SET http_proxy=
SET https_proxy=
SET no_proxy=

SET boot2dockerBoxPath=file://%rootPathReverse%/Virtual Machines/Windows Host/Boot2docker (supports docker)/cache/boot2docker-19.03.5.iso
SET boot2dockerStartExtraArgs=

REM Directories inside root folder that will be mounted in the virtual machine.
SET foldersMapping=Virtual Machines:/workspace/Virtual Machines,Configs:/workspace/Configs,Profiles:/workspace/Profiles,Workspace:/workspace/Workspace

REM Ports mapped between the host machine and the guest / virtual machine (format: <host port A>:<guest port A>,<host port B>:<guest port B>...)
SET portsMapping=2222:22,8080:8080,8081:8081,8082:8082