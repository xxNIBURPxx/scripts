#Windows Server 2022 install
#win2022-ges-internal.ps1

$NewNameInput = Read-Host "What will the Computer Name be?"

if ($NewNameInput -eq '')
	{
		Write-Host 'Error: Copy/Paste of script detected.... No Computer Name Detected' -ForegroundColor Red
		write-host 'Please run this as a script or through the Powershell ISE' -ForegroundColor Red
		write-host 'The script will continue but will join donain using current computer name.' -ForegroundColor Red
		$NewName = $env:ComputerName
		$NewNameGroup = $NewName + '$'
	}
else
    {
		$NewName = $NewNameInput
		$NewNameGroup = $NewName + '$'
    }

$Credentials = Get-Credential

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
Get-NetAdapterBinding |  Disable-NetAdapterBinding -ComponentID ms_tcpip6

#Get-NetAdapter | Disable-NetAdapterBinding -ComponentID ms_tcpip6

#Enable secure RDP and allow through windows firewall
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -name "fDenyTSConnections" -Value 0
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"
set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" -name "UserAuthentication" -Value 1

#Remove Windows Defender Feature 
Uninstall-WindowsFeature -Name Windows-Defender

Import-Module ServerManager

$snmpcheck = Get-WindowsFeature -Name SNMP-Service

 ##Verify Windows Services Are Enabled
 If ($snmpcheck.Installed -ne "True")
	{
		Write-Host "SNMP Service Installing..."
		Get-WindowsFeature -name SNMP* | Add-WindowsFeature -IncludeManagementTools | Out-Null
	}

#Join Domain

#Moved to top $Credentials = Get-Credential
#$Domain = Read-Host "Enter Domain to join (ex:ges.intra)"
$Domain = "ges.intra"
#$OUPath = Read-Host "Enter OU Path (ex: OU=UK,OU=Member Servers,OU=GES,DC=ges,DC=intra)"
$OUPath = "OU=Pursuit,OU=Prod,OU=_Servers,DC=ges,DC=intra"

if ($NewName -eq $env:ComputerName)
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -Restart -Force -Server "USNV01-GESDC01.ges.intra"
	}
else
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -NewName $NewName -Restart -Force #-Server "USNV01-GESDC01.ges.intra"
	}
