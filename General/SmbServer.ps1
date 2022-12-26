#Get SmbServer config
Get-SmbServerConfiguration | Select EnableSMB1Protocol

#Set SmbServer true or false
Set-SmbServerConfiguration -EnableSMB1Protocol $false

Set-SmbServerConfiguration -EnableSMB1Protocol $true