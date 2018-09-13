param(
[parameter(Mandatory=$false)][string]$wslDistroArchive = ".\Alpine.zip",
[parameter(Mandatory=$false)][string]$name = "Alpine",
[parameter(Mandatory=$false)][string]$wslDistro = $name + ".exe",
[parameter(Mandatory=$false)][string]$wslPath = "C:\wsl\"+$name,
[parameter(Mandatory=$false)][string]$wslPath_lnx = "/mnt/c/wsl/" + $name,
[parameter(Mandatory=$false)][string]$wslDistro_oem = $wslPath + "\Alpine.exe",
[parameter(Mandatory=$false)][string]$user = $env:UserName.ToLower(),
[parameter(Mandatory=$true)][string]$email = "first.last@domain.com"
)

Write-Host -ForegroundColor Yellow ("`nEnter Administrator Credentials for this computer to check if  Windows Subsystem for Linux (WSL)is enabled")
$wslStatus = Start-Process powershell.exe -Verb Runas -ArgumentList "`nGet-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux"
if ($wslStatus.status -eq "Disabled") {
	Write-Host -ForegroundColor Yellow ("`nEnter Administrator Credentials for this computer to enabled Windows Subsystem for Linux (WSL), Reboot and then continue script upon login")
	Start-Process powershell.exe -Verb Runas -ArgumentList "`nEnable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart"
	Restart-Computer -Wait
}

Write-Host -ForegroundColor Green ("`nWindows Subsystem for Linux (WSL) is enabled")

# Uninstall previous WSL distro if present
if (Test-Path $wslPath) {
    Write-Host -ForegroundColor Yellow ("`nUninstalling previous Windows Subsystem for Linux (WSL), $wslDistro Linux")
    Start-Process $wslPath\$wslDistro -ArgumentList "clean" -NoNewWindow -Wait
    Remove-Item -Recurse -Force $wslPath
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux FOUND and REMOVED.")
}
else {
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux NOT found.")
}

# Install WSL Distro
Write-Host -ForegroundColor Yellow ("`nInstalling Windows Subsystem for Linux (WSL), $wslDistro Linux")
Invoke-Command -ScriptBlock { Expand-Archive -Path $args[0] -DestinationPath $args[1] -Force } -ArgumentList $wslDistroArchive,$wslPath
Invoke-Command -ScriptBlock { Copy-Item -Recurse -Path .\py2_sphinx_wsl_install -Destination $args[0] -Force } -ArgumentList $wslPath
Invoke-Command -ScriptBlock { Rename-Item -Path $args[0] -NewName $args[1] -Force } -ArgumentList $wslDistro_oem,$wslDistro
Start-Process $wslPath\$wslDistro -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run cd /usr/share/texmf-dist/tex/latex/acrotex; sudo latex acrotex.ins" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo mktexlsr" -NoNewWindow -Wait # would like to add this to makefile
#Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.filemode false" -NoNewWindow
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.autocrlf false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.symlinks false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system rebase.autosquash true" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system lfs.activitytimeout 0" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system credential.helper 'cache --timeout 30000'" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git lfs install"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo ln -s /usr/bin/python3 /usr/bin/python"
Write-Host -ForegroundColor Yellow ("`nSet password for $user when prompted")
Start-Process $wslPath\$wslDistro -ArgumentList "run adduser $user --shell bash --uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run echo '$user ALL=(ALL) ALL' >> /etc/sudoers" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "config --default-uid 1000" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run echo export PLANTUML=/usr/local/plantuml.jar >> ~/.bash_profile"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run echo from pprint import pprint >> ~/.pyrc"  -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global http.sslVerify false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.name $user"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git config --global user.email '$email'"  -NoNewWindow -Wait
Remove-Item -Force $wslPath\rootfs.tar.gz
Write-Host -ForegroundColor Green ("`nInstallation of Windows Subsystem for Linux (WSL), $wslDistro Linux is complete")
