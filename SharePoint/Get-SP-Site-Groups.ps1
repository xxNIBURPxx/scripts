#Connect to SharePoint online
Connect-SPOService -Url https://viadcorp-admin.sharepoint.com

#Get SharePoint site group
Get-SPOSiteGroup -Site https://viadcorp.sharepoint.com/sites/FlyOverConstructionCoreProjectTeam

Get-SPOSiteGroup -Site https://viadcorp.sharepoint.com/sites/FlyOverConstructionCoreProjectTeam | Select-Object LoginName, Title, OwnerLoginName | Export-csv -NoTypeInformation -Path C:\Temp\SharePoint-Reports\FlyOverConstructionCoreProjectTeam.csv


$SiteURL="https://viadcorp.sharepoint.com/sites/CafeTeam"
$GroupName= "Cafe Team Visitors"
   
#sharepoint online powershell get group members
Get-SPOUser -Site $SiteURL -Group $GroupName | Export-CSV C:\Temp\SharePoint-Reports\CafeTeam-visitors.csv

$SiteURL="https://viadcorp.sharepoint.com/sites/CafeTeam"
$GroupName= "Cafe Team Members"
   
#sharepoint online powershell get group members
Get-SPOUser -Site $SiteURL -Group $GroupName | Export-CSV C:\Temp\SharePoint-Reports\CafeTeam-members.csv

$SiteURL="https://viadcorp.sharepoint.com/sites/FlyOverConstructionCoreProjectTeam"
$GroupName= "FlyOverConstructionCoreProjectTeam Owners"
   
#sharepoint online powershell get group members
Get-SPOUser -Site $SiteURL -Group $GroupName | Export-CSV C:\Temp\SharePoint-Reports\FlyOverConstructionCoreProjectTeam-owners.csv