#Connect to SharePoint online
Connect-SPOService -Url https://viadcorp-admin.sharepoint.com

#Set user as site collection admin
$SiteURL = "https://viadcorp.sharepoint.com/sites/JK-FOLV"
$ADGroupID = "9524fde0-1764-4dd6-88a4-dd8efa4d3606"
 
$LoginName = "c:0t`.c`|tenant`|$ADGroupID"
 
Try {
    #Connect to SharePoint Online
    $Site = Get-SPOSite $SiteURL
  
    Write-host -f Yellow "Adding AD Group as Site Collection Administrator..."
    Set-SPOUser -site $Site -LoginName $LoginName -IsSiteCollectionAdmin $True
    Write-host -f Green "Done!"
}
Catch {
    write-host -f Red "Error:" $_.Exception.Message
}
