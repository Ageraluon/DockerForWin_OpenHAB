#Check if mounted folders are empty (usually at first start), and move original folders into mounts
if (-NOT (Test-Path .\addons\*)) {Copy-item -Force -Recurse .\addons-org\* -Destination .\addons\}
if (-NOT (Test-Path .\conf\*)) {Copy-item -Force -Recurse .\conf-org\* -Destination .\conf\}
if (-NOT (Test-Path .\userdata\*)) {Copy-item -Force -Recurse .\userdata-org\* -Destination .\userdata\}

#possible ways tried to start OpenHAB
#.\start.bat 
#cmd.exe /c 'call .\start_debug.bat'
.\runtime\bin\karaf.bat debug
