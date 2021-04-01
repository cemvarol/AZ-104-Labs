Set-NetFirewallProfile -Enabled False
cd\
mkdir SC
$url = "https://raw.githubusercontent.com/cemvarol/AZ-400-JenkinsLab/master/DL-DocDT.ps1"
$output = "C:\SC\DockerDL.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Sleep -s 5
Start-Process Powershell.exe -Argumentlist "-file C:\SC\DockerDL.ps1"
#
