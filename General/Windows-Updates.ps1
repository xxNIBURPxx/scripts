# Authored by Phil Rubin
# This script is for running windows updates, set the NTP server pool and resync the time with the NTP pool
# Temporarily enables the vNIC, Windows Update Service and date/time service.  All will again be disabled after running the tasks in the script.

# Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

# Enable vNIC
netsh interface set interface "Ethernet0" admin=enable
TIMEOUT /T 30

# Install Windows update module
Install-Module PSWindowsUpdate -f
TIMEOUT /T 10

# Set NTP server and sync
Push-Location
Set-Location HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers
Set-ItemProperty . 0 "1.us.pool.ntp.org"
Set-ItemProperty . "(Default)" "0"
Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters
Set-ItemProperty . NtpServer "1.us.pool.ntp.org"
Pop-Location
Start-Service w32time
w32tm /resync
Stop-Service w32time

# Enable windows udpate service
Start-Service -Name "Windows Update"

# Download and Install Windows Updates
Get-WindowsUpdate -AcceptAll -Install -AutoReboot
# To prevent automatic reboot after updates remove "-AutoReboot"

# Disable windows update service
Stop-Service -Name "Windows Update"

# Enable Windows Defender service
Set-MpPreference -DisableRealtimeMonitoring $false

# Run Windows Defender full scan
Start-MpScan -ScanType FullScan

# Stop Windows defender service
Set-MpPreference -DisableRealtimeMonitoring $true

# Disable vNIC
netsh interface set interface "Ethernet0" admin=disable
