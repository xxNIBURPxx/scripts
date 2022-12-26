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

#Change CDROM drive to H instead of D.
(gwmi Win32_cdromdrive).drive | %{$a = mountvol $_ /l;mountvol $_ /d;$a = $a.Trim();mountvol h: $a}

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

#Install Kace Agent
#Software Distribution/Kace/ampagent-10.2.108-x86_kace01.ges.intra.msi

$BlobUri = 'https://gesusit.file.core.windows.net/ges-us-it-data/Software%20Distribution/Kace/ampagent-10.2.108-x86_kace01.ges.intra.msi'
$Sas = '?st=2022-01-12T19%3A52%3A56Z&se=2024-02-13T19%3A52%3A00Z&sp=rl&sv=2018-03-28&sr=f&sig=O8HHNePjZtrwp%2BmX5UPJxou5L23%2BfBN3h08scMsiz8o%3D'

#Make the path if it doesn't exist
$path = "C:\_Workfile\Kace"
If (!(test-path $path))
{
	New-Item -ItemType Directory -Force -Path $path
}

#Output Path with \ on the end
$OutputPath = 'C:\_Workfile\Kace\'

#File Name
$File = "C:\_Workfile\Kace\ampagent-10.2.108-x86_kace01.ges.intra.msi"


#Gets full Uri
$FullUri = "$BlobUri$Sas"

#Downloads file to outpath with correct file type and file found in BlobURI
(New-Object System.Net.WebClient).DownloadFile($FullUri, $OutputPath + ($BlobUri -split '/')[-1])

#Install Kace
Start-Process "msiexec" -verb RunAs -ArgumentList "/qn /i $File HOST=kace01.ges.intra" -PassThru -Wait

#Install Cisco Secure Endpoint
#Software Distribution/Cisco Secure Endpoint/amp_Servers_Ring_2_Production.exe

$BlobUri = 'https://gesusit.file.core.windows.net/ges-us-it-data/Software%20Distribution/Cisco%20Secure%20Endpoint/amp_Servers_Ring_2_Production.exe'
$Sas = '?st=2022-01-11T15%3A38%3A37Z&se=2025-01-12T15%3A38%3A00Z&sp=rl&sv=2018-03-28&sr=f&sig=%2FnG1BhTPZFr7a69dw71NjFQo3Z9R5BGLWAtVw5Ptt2k%3D'

#Make the path if it doesn't exist
$path = "C:\_Workfile\Cisco Secure Endpoint"
If (!(test-path $path))
{
	New-Item -ItemType Directory -Force -Path $path
}

#Output Path with \ on the end
$OutputPath = 'C:\_Workfile\Cisco Secure Endpoint\'

#Gets full Uri
$FullUri = "$BlobUri$Sas"

#File Name
$File = "C:\_Workfile\Cisco Secure Endpoint\amp_Servers_Ring_2_Production.exe"

#Downloads file to outpath with correct file type and file found in BlobURI
(New-Object System.Net.WebClient).DownloadFile($FullUri, $OutputPath + ($BlobUri -split '/')[-1])

#Install
cd $OutputPath
.\amp_Servers_Ring_2_Production.exe

Import-Module ServerManager

$snmpcheck = Get-WindowsFeature -Name SNMP-Service

 ##Verify Windows Services Are Enabled
 If ($snmpcheck.Installed -ne "True")
	{
		Write-Host "SNMP Service Installing..."
		Get-WindowsFeature -name SNMP* | Add-WindowsFeature -IncludeManagementTools | Out-Null
	}

#Setup script to resume following domain join and reboot

mkdir c:\temp

set-location HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce
new-itemproperty . MyKey -propertytype String -value 'c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -noexit "C:\temp\part2.ps1"'

#Step 2 updates the Nagios config and then triggers a Windows Update installation and reboot if needed.


$Step2 = '

$KDownload = "C:\_Workfile\KcsSetup.exe"  
Invoke-WebRequest "https://iad2vsa02.kaseya.net/mkDefault.asp?id=23513740"  -OutFile $KDownload
Start-Process $KDownload

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

#Clean up self and temp file
# this script deletes itself.
Remove-Item $MyINvocation.InvocationName -Recurse -Force
Remove-Item "c:\temp" -Recurse -Force
	
#Reboot.

shutdown.exe /t 600 /r

exit

'

$Step2 | Out-File "C:\temp\part2.ps1"


#Join Domain

#Moved to top $Credentials = Get-Credential
#$Domain = Read-Host "Enter Domain to join (ex:ges.intra)"
$Domain = "ges.intra"
#$OUPath = Read-Host "Enter OU Path (ex: OU=UK,OU=Member Servers,OU=GES,DC=ges,DC=intra)"
$OUPath = "OU=Pursuit,OU=_Servers,DC=ges,DC=intra"

if ($NewName -eq $env:ComputerName)
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -Restart -Force -Server "USNV01-GESDC01.ges.intra"
	}
else
	{
		Add-computer -DomainName $Domain -OUPath $OUPath -Credential $Credentials -NewName $NewName -Restart -Force #-Server "USNV01-GESDC01.ges.intra"
	}
