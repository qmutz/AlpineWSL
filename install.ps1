param(
[parameter(Mandatory=$false)][string]$distroName = "Alpine",
[parameter(Mandatory=$false)][string]$user = $env:UserName.ToLower(),
[parameter(Mandatory=$true)][string]$email = "username@domain.com",
[parameter(Mandatory=$false)][string]$wslDistro = $distroName + ".exe",
[parameter(Mandatory=$false)][string]$wslPath = "C:\Users\$user\.wsl\"+$distroName,
[parameter(Mandatory=$false)][string]$wslDistro_oem = $wslPath + "\$distroName.exe",
[parameter(Mandatory=$false)][string]$TargetFile = "$wslPath\$wslDistro",
[parameter(Mandatory=$false)][string]$ShortcutFile = "C:\Users\$user\Desktop\$distroName WSL.lnk"
)

Start-Transcript -path C:\TEMP\install-$wslDistro.log -append

# Uninstall previous WSL distro if present
If (Test-Path $wslPath) {
    Write-Host -ForegroundColor Yellow ("`nUninstalling previous Windows Subsystem for Linux (WSL), $wslDistro Linux")
    Start-Process $wslPath\$wslDistro -ArgumentList "clean" -NoNewWindow -Wait
    Get-ChildItem -Path $wslPath -Recurse | Remove-Item -force -recurse
    Remove-Item -Force $ShortcutFile
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux FOUND and REMOVED.")
}
Else {
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux NOT found.")
}

# Install WSL Distro
Write-Host -ForegroundColor Yellow ("`nInstalling Windows Subsystem for Linux (WSL), $wslDistro Linux to $wslPath")
Invoke-Command -ScriptBlock { Copy-Item -Recurse -Path .\ -Destination $args[0] -Force } -ArgumentList $wslPath

Start-Process $wslPath\$wslDistro -ArgumentList "silent" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run cd /usr/share/texmf-dist/tex/latex/acrotex; sudo latex acrotex.ins" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo mktexlsr" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.autocrlf false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.symlinks false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system rebase.autosquash true" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system lfs.activitytimeout 0" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system credential.helper 'cache --timeout 30000'" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system color.diff false" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git lfs install"  -NoNewWindow -Wait
Write-Host -ForegroundColor Green ("`nInstallation of Windows Subsystem for Linux (WSL), $wslDistro Linux is complete")

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

# Create desktop shortcut for user
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()

# Cleanup
Remove-Item -Force $wslPath\rootfs.tar.gz
Remove-Item -Force $wslPath\addWSLfeature.ps1
Remove-Item -Force $wslPath\install.ps1

Write-Host -ForegroundColor Green ("`nUser Configuration of user:$user for Windows Subsystem for Linux (WSL), $wslDistro Linux is complete")

Stop-Transcript
