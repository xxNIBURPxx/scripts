#Remove old PnP version if installed
Uninstall-Module -Name SharePointPnPPowerShellOnline -AllVersions -Force

#Install Pnp module
Install-Module -Name PnP.PowerShell
