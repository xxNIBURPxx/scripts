[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic') 
$idracip = [Microsoft.VisualBasic.Interaction]::InputBox('Enter IP Address of idrac to configure:', 'IP Address') 
if ($idracip -eq $null -or $idracip -eq "")
{
    Break Script
}

$idracname = [Microsoft.VisualBasic.Interaction]::InputBox('Enter Name of idrac to be used::', 'Example: usak12-esx01-lo') 
if ($idracname -eq $null -or $idracname -eq "")
{
    Break Script
}

$idracfqdn = "$idracname.ges.intra"

$idracpwoptions =  [System.Windows.MessageBox]::Show('Is this using the default root password? ','Please Select','YesNoCancel','info')

  switch  ($idracpwoptions) {

  'Yes' {

            $idracpass = "calvin"

        }

  'No' {

            $idracpass = [Microsoft.VisualBasic.Interaction]::InputBox('Enter idrac password to use:', 'Enter password') 
        }

  'Cancel' {

        Break Script

        }

  }

  $TimeZoneOptions = [ordered]@{

  1 = 'US/Pacific'
  2 = 'US/Central'
  3 = 'US/Eastern'
  4 = 'US/Alaska'
  5 = 'US/Arizona'
  6 = 'Europe/London'
  7 = 'GMT'

  }

  

  $Result = $TimeZoneOptions | Out-GridView -PassThru  -Title 'Select Time Zone'
  
  If (!$Result)
  {
  Break Script
  }

  Switch ($Result)  {

  {$Result.Name -eq 1} {$TimeZone = "US/Pacific"}

  {$Result.Name -eq 2} {$TimeZone = "US/Central"}

  {$Result.Name -eq 3} {$TimeZone = "US/Eastern"}  
   
  {$Result.Name -eq 4} {$TimeZone = "US/Alaska"}   
  
  {$Result.Name -eq 5} {$TimeZone = "US/Arizona"}   

  {$Result.Name -eq 6} {$TimeZone = "Europe/London"}   
  
  {$Result.Name -eq 7} {$TimeZone = "GMT"}   
} 




$VSSPass = [Microsoft.VisualBasic.Interaction]::InputBox('Enter password for vssadmin:', 'Enter Password') 

if ($VSSPass -eq $null -or $VSSPass -eq "")
{
    Break Script
}

$VSSPass2 = [Microsoft.VisualBasic.Interaction]::InputBox('Verify password for vssadmin:', 'Enter Password') 
if ($VSSPass2 -eq $null -or $VSSPass2 -eq "")
{
    Break Script
}

$Pass = $VSSPass.CompareTo($VSSPass2)

If ($Pass -eq 0)
    {

    #Create VSSAdminUser
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.Username vssadmin
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.Password $VSSPass
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.Privilege 0x1ff
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.SolEnable Enabled
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.IpmiLanPrivilege 4
    racadm -r $idracip -u root -p $idracpass --nocertwarn set iDRAC.Users.3.Enable Enabled

    #Disable default root account
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Users.2.Enable Disabled

    #Set Network Common Settings 
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NIC.DNSDomainNameFromDHCP Disabled
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NIC.DNSRacName $idracname
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NIC.DNSDomainName ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NIC.DNSRegister Enabled
      
    #Set DNS Servers
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.IPv4.DNSFromDHCP 0
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.IPv4.DNS1 10.111.192.87
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.IPv4.DNS2 10.111.192.88

    #set NTP Servers
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Time.Timezone US/Pacific
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NTPConfigGroup.NTPEnable 1
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NTPConfigGroup.NTP1 10.111.196.196
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.NTPConfigGroup.NTP2 10.111.200.200


    #Setup Alerting
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.ipmilan.alertenable 1
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.ipmilan.CommunityName VSSncmpub
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.snmpalert.1.Destination 10.111.192.91
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.snmpalert.1.State Enabled
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn eventfilters set -c idrac.alert.system.warning -a none -n all
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn eventfilters set -c idrac.alert.system.critical -a none -n all
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn eventfilters set -c idrac.alert.storage.warning -a none -n all
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn eventfilters set -c idrac.alert.storage.critical -a none -n all


    #Setup SNMP Agent
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.snmp.AgentCommunity VSSncmpub
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set idrac.snmp.AgentEnable Enabled

    

    #Setup AD Integration
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.Enable 1
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.Schema 2
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.RACDomain ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.DCLookupDomainName ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.UserDomain.1.Name ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ADGroup.1.Name RG-IDRAC-Server-Administrators
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ADGroup.1.Domain ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ADGroup.1.Privilege 0x1ff
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.DomainController1 10.111.192.87
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.DomainController2 10.111.192.88
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.GlobalCatalog1 10.111.192.87
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.GlobalCatalog2 10.111.192.88
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.ActiveDirectory.CertValidationEnable 0


    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrKeySize 2048
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrCommonName $idracfqdn
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrOrganizationName Viad
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrOrganizationUnit IT
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrEmailAddr systemsteam@viad.com
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrStateName Arizona
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn set iDRAC.Security.CsrLocalityName Phoenix
    Start-Sleep -s 60
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn sslcsrgen -g -f "C:\SSL\IDRAC\$idracname.csr"
    $RequestFile = "C:\SSL\IDRAC\$idracname.csr"

    certreq -submit -config usnv01-intca01.ges.intra\VIADCA-INT01 -attrib "CertificateTemplate:WebServer" $RequestFile C:\SSL\IDRAC\$idracname.cer

    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn sslcertupload -t 1 -f c:\SSL\IDRAC\$idracname.cer
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn racreset
    }

Else
    {
    [System.Windows.MessageBox]::Show('vssadmin passwords do not match')
    }


