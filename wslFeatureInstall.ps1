Start-Transcript -path C:\TEMP\wslFeatureInstall.log -append
$wslState = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
if ($wslState.State -eq "Disabled") {
	Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
	Write-Host -ForegroundColor Yellow ("`nWindows Subsystem for Linux (WSL) is enabled, Please manually restart your host before installing a WSL Distrobution")
}
Write-Host -ForegroundColor Green ("`nWindows Subsystem for Linux (WSL) is enabled")
Stop-Transcript
