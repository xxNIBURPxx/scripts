$NewNameInput = Read-Host "What will the Computer Name be?"

#test

if ($NewNameInput -eq '')
	{
		Write-Host 'Error: Copy/Paste of script detected.... No Computer Name Detected' -ForegroundColor Red
		write-host 'Please run this as a script or through the Powershell ISE' -ForegroundColor Red
		write-host 'The script will continue but will join donain using current computer name.' -ForegroundColor Red
		$NewName = $env:ComputerName
	}
else
    {
        $NewName = $NewNameInput
    }

#Change CDROM drive to H instead of D.
(gwmi Win32_cdromdrive).drive | %{$a = mountvol $_ /l;mountvol $_ /d;$a = $a.Trim();mountvol h: $a}

#Cleanup G Drive Favorites Reg Entries

Remove-ItemProperty -Path 'registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders' -Name Favorites -Force -ea silentlycontinue
Remove-ItemProperty -Path 'registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' -Name Favorites -Force -ea SilentlyContinue
Remove-ItemProperty -Path 'registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\Explorer\Shell folders' -Name Favorites -Force -ea SilentlyContinue
Remove-ItemProperty -Path 'registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\Explorer\User Shell folders' -Name Favorites -Force -ea SilentlyContinue

#Disable IE Enhanced Security Config for Admins
New-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -Name “IsInstalled” -Value 0 -Force

#Install .net 3.5 and 4.6

Import-Module ServerManager

# Get Windows Server Version
$WindowsVersion = [environment]::OSVersion.Version


#Check for .net 3.5
$net35check = Get-WindowsFeature -Name NET-Framework-Core

#Check for .net 4.6
$net46check = Get-WindowsFeature -Name Net-Framework-45-Core

#Add 3.5 and 4.6 if necessary
If ($net35check.Installed -ne "True")
	{
		Write-Host ".net 3.5 Installing..."
		Add-WindowsFeature Net-Framework-Core
	}

If ($net46check.Installed -ne "True")
	{
		Add-WindowsFeature Net-Framework-45-Core
	}

#Disable SSLv2

if (!(Test-Path -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Server'))
	{New-Item -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Server'}

New-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Server' -Name Enabled -Value 0 -Force

if (!(Test-Path -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Client'))
	{New-Item -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Client'}

New-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SecurityProviders\SChannel\Protocols\SSL 2.0\Client' -Name Enabled -Value 0 -Force


#Enable UAC
New-ItemProperty -Path 'registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name EnableLUA -Value 1 -Force

#Disable 6to4 Tunnel Adapter
netsh int 6to4 set state state=disabled undoonstop=disabled

#Disable IPV6
New-ItemProperty -Path 'registry::HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' -Name DisabledComponents -Value 0xffffffff -PropertyType "DWord" -Force
#Get-NetAdapter | Disable-NetAdapterBinding -ComponentID ms_tcpip6

#Remove Windows Defender Feature 
Uninstall-WindowsFeature -Name Windows-Defender

#Disable Other Unessessary Services
Set-Service -Name CDPUserSvc -StartupType Disabled
Set-Service -Name OneSyncSvc -StartupType Disabled
Set-Service -Name DiagTrack -StartupType Disabled
Set-Service -Name lfsvc -StartupType Disabled
Set-Service -Name MapsBroker -StartupType Disabled
Set-Service -Name Themes -StartupType Disabled
Set-Service -Name XblAuthManager -StartupType Disabled
Set-Service -Name XblGameSave -StartupType Disabled

#Setup script to resume following domain join and reboot

mkdir c:\temp

set-location HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
new-itemproperty . MyKey -propertytype String -value 'c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit "C:\temp\part2.ps1"'

#Step 2 updates the Nagios config and then triggers a Windows Update installation and reboot if needed.


$Step2 = '

#Cleanup G Drive Favorites Reg Entries

Remove-ItemProperty -Path "registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" -Name Favorites -Force -ea silentlycontinue
Remove-ItemProperty -Path "registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name Favorites -Force -ea silentlycontinue
Remove-ItemProperty -Path "registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\Explorer\Shell folders" -Name Favorites -Force -ea silentlycontinue
Remove-ItemProperty -Path "registry::HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CurrentVersion\Explorer\User Shell folders" -Name Favorites -Force -ea silentlycontinue

#Enable secure RDP and allow through windows firewall
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1  

#Installing Cisco AMP
Write-Host "Installing KACE Agent"
(New-Object -com Shell.Application).ShellExecute("\\ges.intra\gesdfs\KACE\Cisco\AMP\Server_FireAMPSetup.exe") | Out-Null

#Check for BGINFO...install if missing

if (!(Test-Path -Path "c:\BGInfo\get_ad_site.vbs"))
	{
		mkdir c:\BGInfo
		copy-item \\smdata02.ges.intra\T3-Sft\Bginfo\* c:\BGInfo -force -recurse -verbose
		
		if ($ENV:PROCESSOR_ARCHITECTURE -eq "AMD64")
			{
				Write-Host "Setting up for 64bit"
				Copy-Item C:\BGInfo\bginfo-local64.cmd "$env:ALLUSERSPROFILE\Start Menu\Programs\Startup\" -force
				$BGRun = Start-Process "$env:ALLUSERSPROFILE\Start Menu\Programs\Startup\bginfo-local64.cmd" -verb RunAs -Wait -PassThru
			}
		else 
			{
				Write-Host "Setting up for 32bit"
				Copy-Item C:\BGInfo\bginfo-local.cmd "$env:ALLUSERSPROFILE\Start Menu\Programs\Startup\" -force
				$BGRun = Start-Process "$env:ALLUSERSPROFILE\Start Menu\Programs\Startup\bginfo-local.cmd" -verb RunAs -Wait -PassThru
			}
	
	}

#Check for SNMP, install if missing

Import-Module ServerManager

$snmpcheck = Get-WindowsFeature -Name SNMP-Service

 ##Verify Windows Services Are Enabled
 If ($snmpcheck.Installed -ne "True")
	{
		Write-Host "SNMP Service Installing..."
		Get-WindowsFeature -name SNMP* | Add-WindowsFeature -IncludeManagementTools | Out-Null
	}

#Install KACE agent
Write-Host "Installing KACE Agent"
$setup=Start-Process "msiexec" -verb RunAs -ArgumentList "/qn /i \\kace01.ges.intra\client\agent_provisioning\windows_platform\ampagent-8.0.152-x86.msi HOST=kace01.ges.intra" -PassThru -Wait 


#Run Windows Update

Write-Host Checking for Windows Updates...

#Define update criteria.

$Type = ''Software''

$Criteria = "IsInstalled=0 and Type=''$Type''"


#Search for relevant updates.

$Searcher = New-Object -ComObject Microsoft.Update.Searcher

$SearchResult = $Searcher.Search($Criteria).Updates

if ($SearchResult.Count -eq 0) 
	{"There are no applicable updates."}
Else 
	{
		#Download updates.
		Write-Host Downloading $SearchResult.Count Updates...
		$Session = New-Object -ComObject Microsoft.Update.Session

		$Downloader = $Session.CreateUpdateDownloader()

		$Downloader.Updates = $SearchResult

		$Downloader.Download()
		
		#Install updates.
		Write-Host Installing $SearchResult.Count Updates...

		$Installer = New-Object -ComObject Microsoft.Update.Installer

		$Installer.Updates = $SearchResult

		$Result = $Installer.Install()
	}

#Install Solarwinds Agent
Write-Host "Installing Solarwinds Agent"
$setup=Start-Process "msiexec" -verb RunAs -ArgumentList "/i \\smdata02.ges.intra\T3-Sft\Solarwinds\Solarwinds-Agent.msi /passive TRANSFORMS=\\smdata02.ges.intra\T3-Sft\Solarwinds\SolarWinds-Agent-AgentInitiated.mst" -PassThru -Wait 

#Clean up self and temp file
# this script deletes itself.
Remove-Item $MyINvocation.InvocationName -Recurse -Force
Remove-Item "c:\temp" -Recurse -Force
	
#Reboot if required by updates.

If ($Result.rebootRequired) { shutdown.exe /t 600 /r }

exit

'

$Step2 | Out-File "C:\temp\part2.ps1"


#Join Domain

$Credentials = Get-Credential
#$Domain = Read-Host "Enter Domain to join (ex:ges.intra)"
$Domain = 'ges.intra'
#$OUPath = Read-Host "Enter OU Path (ex: OU=UK,OU=Member Servers,OU=GES,DC=ges,DC=intra)"
$OUPath = 'OU=Pursuit,OU=_Servers,DC=ges,DC=intra'

if ($NewName -eq $env:ComputerName)
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -Restart -Force -Server "USNV01-GESDC01.ges.intra"
	}
else
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -NewName $NewName -Restart -Force -Server "USNV01-GESDC01.ges.intra"
	}