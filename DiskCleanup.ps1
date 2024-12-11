Write-Host "<-Start Result->"

# 1. Clear Windows Update Cache
Write-Host "Clearing Windows Update cache..."
Stop-Service -Name wuauserv -Force
Stop-Service -Name bits -Force
Remove-Item -Path "C:\Windows\SoftwareDistribution" -Recurse -Force
Start-Service -Name wuauserv
Start-Service -Name bits
Write-Host "Windows Update cache cleared."

# 2. Clear Temp Files
Write-Host "Clearing system temporary files..."
Get-ChildItem -Path "C:\Windows\Temp" -Recurse | Remove-Item -Force -Recurse
Write-Host "System temporary files cleared."

# 3. Clear User Temp Files
Write-Host "Clearing user temporary files..."
Get-ChildItem -Path "$env:Temp" -Recurse | Remove-Item -Force -Recurse
Write-Host "User temporary files cleared."

# 4. Remove Old Windows Updates
Write-Host "Cleaning up old Windows Updates..."
Dism.exe /online /Cleanup-Image /StartComponentCleanup /Quiet
Write-Host "Old Windows Updates cleaned up."

# 5. Clear Recycle Bin for All Users
Write-Host "Clearing Recycle Bin for all users..."
Get-ChildItem -Path 'C:\$Recycle.Bin' -Recurse -Force | Remove-Item -Force -Recurse
Write-Host "Recycle Bin cleared for all users."

# 6. Delete Windows Error Reporting Files
Write-Host "Deleting Windows Error Reporting files..."
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\WER\ReportQueue" -Recurse -Force
Write-Host "Windows Error Reporting files deleted."

# 7. Clear IIS Logs (if applicable)
Write-Host "Clearing IIS logs (if applicable)..."
if (Test-Path "C:\inetpub\logs\LogFiles") {
    Remove-Item -Path "C:\inetpub\logs\LogFiles\*" -Recurse -Force
    Write-Host "IIS logs cleared."
} else {
    Write-Host "IIS logs not found. Skipping."
}

# 8. Remove Hibernate File
Write-Host "Disabling and removing hibernation file..."
powercfg -h off
Write-Host "Hibernate file removed."

# 9. Clear Event Logs
Write-Host "Clearing event logs..."
wevtutil el | ForEach-Object { wevtutil cl $_ }
Write-Host "Event logs cleared."

Write-Host "<-End Result->"