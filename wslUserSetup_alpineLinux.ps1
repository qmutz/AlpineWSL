param(
[parameter(Mandatory=$false)][string]$name = "Alpine",
[parameter(Mandatory=$false)][string]$wslDistro = $name + ".exe",
[parameter(Mandatory=$false)][string]$wslPath = "C:\wsl\"+$name,
[parameter(Mandatory=$false)][string]$user = $env:UserName.ToLower(),
[parameter(Mandatory=$true)][string]$email = "first.last@domain.com"
)

Start-Transcript -path .\wslDistroUser.log -append

# Configure user for WSL Distro
Write-Host -ForegroundColor Yellow ("`nConfiguring user:$user for Windows Subsystem for Linux (WSL), $wslDistro Linux")
Write-Host -ForegroundColor Yellow ("`nSet password for $user when prompted")
Start-Process $wslPath\$wslDistro -ArgumentList "run adduser $user --shell bash --uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run echo '$user ALL=(ALL) ALL' >> /etc/sudoers" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "config --default-uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run echo export PLANTUML=/usr/local/plantuml.jar >> ~/.bash_profile"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run echo from pprint import pprint >> ~/.pyrc"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global http.sslVerify false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.name $user"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.email '$email'"  -NoNewWindow -Wait
Write-Host -ForegroundColor Green ("`nConfiguration of user:$user for Windows Subsystem for Linux (WSL), $wslDistro Linux is complete")
Stop-Transcript
