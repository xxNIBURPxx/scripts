# Authored by Phil Rubin
# Purpose is for Medialon servers to: Sync time, run updates and run a full Windows Defender system scan
# Script Stages:
# 1) Enable NIC (allowing outbound/inbound internet)
# 2) Install Windows update PS module if not already installed
# 3) Set NTP server, start time service, snyc time and stop service after time is synced
# 4) Enable Windows Update Service
# 5) Download and install available Windows updates (Auto reboot enabled)
# 6) Stop Windows Update service
# 7) Enable Windows Defender realtime monitoring and run a full scan
# 8) Disable Windows Defender realtime monitoring
# 9) Disable NIC (removing outbound/inbound internet)

# Set execution policy to install required PowerShell modules
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

# Enable NIC
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

# Disable NIC
    netsh interface set interface "Ethernet0" admin=disable
