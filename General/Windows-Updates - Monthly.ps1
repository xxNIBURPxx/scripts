# Authored by Phil Rubin
# Windows updates

# Set execution policy to install required PowerShell modules
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

    # Install Windows update module
    Install-Module PSWindowsUpdate -f
    TIMEOUT /T 10

# Download and Install Windows Updates
# To prevent automatic reboot after updates remove "-AutoReboot"
    Get-WindowsUpdate -AcceptAll -Install -AutoReboot
