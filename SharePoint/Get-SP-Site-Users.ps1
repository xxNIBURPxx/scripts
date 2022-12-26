#Connect to SharePoint online
Connect-SPOService -Url https://viadcorp-admin.sharepoint.com

$SiteURL="https://viadcorp.sharepoint.com/sites/FOIPre-OpeningProjectTeam"
   
#sharepoint online powershell get group members
Get-SPOUser -Site $SiteURL | Export-CSV C:\Temp\SharePoint-Reports\FOIPre-OpeningProjectTeam.csv