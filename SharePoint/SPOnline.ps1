#Install SharePoint online module
Install-Module -Name Microsoft.Online.SharePoint.PowerShell

#Connect to SharePoint online
Connect-SPOService -Url https://viadcorp-admin.sharepoint.com

#Get SharePoint site
Get-SPOSite -Filter "URL -like 'nova'"

#Get SharePoint site group
Get-SPOSiteGroup -Site https://viadcorp.sharepoint.com/sites/FlyOverSortingApp

Get-SPOSiteGroup -Site https://viadcorp.sharepoint.com/sites/PursuitFlyOverLasVegas | Select-Object LoginName, Title, OwnerLoginName | Export-csv -NoTypeInformation -Path C:\Temp\SharePoint-Reports\PursuitFlyOverLasVegas.csv

$SiteURL="https://viadcorp.sharepoint.com/sites/PursuitFlyOverLasVegas"
$GroupName= "Pursuit FlyOver Las Vegas Members"
   
#sharepoint online powershell get group members
Get-SPOUser -Site $SiteURL -Group $GroupName