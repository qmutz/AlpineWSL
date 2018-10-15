param(
[parameter(Mandatory=$false)][string]$name = "Alpine",
[parameter(Mandatory=$false)][string]$wslDistro = $name + ".exe",
[parameter(Mandatory=$false)][string]$wslPath = "C:\wsl\"+$name,
[parameter(Mandatory=$false)][string]$wslDistro_oem = $wslPath + "\Alpine.exe"
)

Start-Transcript -path C:\TEMP\install.log -append

# Uninstall previous WSL distro if present
If (Test-Path $wslPath) {
    Write-Host -ForegroundColor Yellow ("`nUninstalling previous Windows Subsystem for Linux (WSL), $wslDistro Linux")
    Start-Process $wslPath\$wslDistro -ArgumentList "clean" -NoNewWindow -Wait
    Remove-Item -Recurse -Force $wslPath
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux FOUND and REMOVED.")
}
Else {
    Write-Host -ForegroundColor Yellow ("`nPrevious Windows Subsystem for Linux (WSL), $wslDistro Linux NOT found.")
}

# Install WSL Distro
Write-Host -ForegroundColor Yellow ("`nInstalling Windows Subsystem for Linux (WSL), $wslDistro Linux")
Invoke-Command -ScriptBlock { Copy-Item -Recurse -Path .\ -Destination $args[0] -Force } -ArgumentList $wslPath
Start-Process $wslPath\$wslDistro -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run cd /usr/share/texmf-dist/tex/latex/acrotex; sudo latex acrotex.ins" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo mktexlsr" -NoNewWindow -Wait # would like to add this to makefile
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.autocrlf false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system core.symlinks false"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system rebase.autosquash true" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system lfs.activitytimeout 0" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system credential.helper 'cache --timeout 30000'" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo git config --system color.ui false" -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run git lfs install"  -NoNewWindow -Wait
Start-Process $wslPath\$wslDistro -ArgumentList "run sudo ln -s /usr/bin/python3 /usr/bin/python" -NoNewWindow -Wait
Remove-Item -Force $wslPath\rootfs.tar.gz
Remove-Item -Force $wslPath\addWSLfeature.ps1
Remove-Item -Force $wslPath\install.ps1
$TargetFile = "$wslDistro_oem"
$ShortcutFile = "$env:Public\Desktop\Alpine WSL.lnk"
$WScriptShell = New-Object -ComObject WScript.Shell
$Shortcut = $WScriptShell.CreateShortcut($ShortcutFile)
$Shortcut.TargetPath = $TargetFile
$Shortcut.Save()
Write-Host -ForegroundColor Green ("`nInstallation of Windows Subsystem for Linux (WSL), $wslDistro Linux is complete")
Stop-Transcript
