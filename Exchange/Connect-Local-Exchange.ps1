#Get user credentials
$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://USNV01-EX01.ges.intra/PowerShell/ -Authentication Kerberos -Credential $UserCredential

Import-PSSession $Session -DisableNameChecking