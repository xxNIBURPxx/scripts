$SiteURL = "https://viadcorp.sharepoint.com/sites/PLRTestSite"
$LibraryName = "Documents"
 
#Connect to SharePoint Online site
Connect-PnPOnline $SiteURL -Interactive
 
#Get the Library
$Library = Get-PnPList -Identity $LibraryName
 
#Set Version History Limit
Set-PnPList -Identity $Library -MajorVersions 50
