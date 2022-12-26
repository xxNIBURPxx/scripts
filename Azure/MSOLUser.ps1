#install msol (run as admin)
Install-Module MSOnline

#connect to msol
Connect-MSOLService

#get user
Get-MsolUser -UserPrincipalName "ahellier@pursuitcollection.com" | select objectid
Get-MsolUser -UserPrincipalName "ychan@pursuitcollection.com"

#set user upn
Set-MsolUserPrincipalName -UserPrincipalName "ychan@viadcorp.onmicrosoft.com" -NewUserPrincipalName "ychan@pursuitcollection.com"

