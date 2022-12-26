#Connect to Microsoft Graph
Connect-Graph -Scopes User.ReadWrite.All, Organization.Read.All

#Get Microsoft license per user
Get-MgUserLicenseDetail -UserId ajonsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ajonsson-licensing.csv
Get-MgUserLicenseDetail -UserId ajonsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ajonsson-license.csv

#Get Microsoft service plans per user
(Get-MgUserLicenseDetail -UserId "ajonsson@pursuitcollection.com" -Property ServicePlans)[0].ServicePlans

#Get ALL Microsoft services per user
$userUPN="ajonsson@pursuitcollection.com"
$allLicenses = Get-MgUserLicenseDetail -UserId $userUPN -Property SkuPartNumber, ServicePlans
$allLicenses | ForEach-Object {
    Write-Host "License:" $_.SkuPartNumber
    $_.ServicePlans | ForEach-Object {$_}
}

#Get SKUs
Get-MsolAccountSku
Get-MsolAccountSku | select -ExpandProperty ServiceStatus

#Get Microsoft license per user bulk
Get-MgUserLicenseDetail -UserId ajonsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ajonsson-license.csv
Get-MgUserLicenseDetail -UserId dmalott@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\dmalott-license.csv
Get-MgUserLicenseDetail -UserId bjonsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\bjonsson-license.csv
Get-MgUserLicenseDetail -UserId gdesk4@pursuit.intra | Export-CSV V:\IT\MS-Licensing\gdesk4-license.csv
Get-MgUserLicenseDetail -UserId korr@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\korr-license.csv
Get-MgUserLicenseDetail -UserId vmehta@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\vmehta-license.csv
Get-MgUserLicenseDetail -UserId hvalgardsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\hvalgardsson-license.csv
Get-MgUserLicenseDetail -UserId rreilly@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\rreilly-license.csv
Get-MgUserLicenseDetail -UserId gphoto1@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\gphoto1-license.csv
Get-MgUserLicenseDetail -UserId prubin@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\prubin-license.csv
Get-MgUserLicenseDetail -UserId pretail@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\pretail-license.csv
Get-MgUserLicenseDetail -UserId gdesk3@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\gdesk3-license.csv
Get-MgUserLicenseDetail -UserId gdesk2@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\gdesk2-license.csv
Get-MgUserLicenseDetail -UserId gdesk1@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\gdesk1-license.csv
Get-MgUserLicenseDetail -UserId cnewton@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\cnewton-license.csv
Get-MgUserLicenseDetail -UserId gugudmundsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\gugudmundsson-license.csv
Get-MgUserLicenseDetail -UserId srunarsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\srunarsson-license.csv
Get-MgUserLicenseDetail -UserId pgudmundsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\pgudmundsson-license.csv
Get-MgUserLicenseDetail -UserId ggudgeirsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ggudgeirsson-license.csv
Get-MgUserLicenseDetail -UserId sgrimarsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\sgrimarsson-license.csv
Get-MgUserLicenseDetail -UserId tolafsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\tolafsson-license.csv
Get-MgUserLicenseDetail -UserId ghallgrimsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ghallgrimsson-license.csv
Get-MgUserLicenseDetail -UserId kolafsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\kolafsson-license.csv
Get-MgUserLicenseDetail -UserId oolafsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\oolafsson-license.csv
Get-MgUserLicenseDetail -UserId ggudmundsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\ggudmundsson-license.csv
Get-MgUserLicenseDetail -UserId pjongeirsson@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\pjongeirsson-license.csv
Get-MgUserLicenseDetail -UserId nikoch@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\nikoch-license.csv
Get-MgUserLicenseDetail -UserId rmunnangi@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\rmunnangi-license.csv
Get-MgUserLicenseDetail -UserId tstaelens@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\tstaelens-license.csv
Get-MgUserLicenseDetail -UserId bmohamed@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\bmohamed-license.csv
Get-MgUserLicenseDetail -UserId sbuettner@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\sbuettner-license.csv
Get-MgUserLicenseDetail -UserId zmchenry@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\zmchenry-license.csv
Get-MgUserLicenseDetail -UserId jzagelbaum@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\jzagelbaum-license.csv
Get-MgUserLicenseDetail -UserId stycast@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\stycast-license.csv
Get-MgUserLicenseDetail -UserId blambrecht@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\blambrecht-license.csv
Get-MgUserLicenseDetail -UserId rvermazen@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\rvermazen-license.csv
Get-MgUserLicenseDetail -UserId dharrington@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\dharrington-license.csv
Get-MgUserLicenseDetail -UserId attractionsAR@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\attractionsAR-license.csv
Get-MgUserLicenseDetail -UserId obourke@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\obourke-license.csv
Get-MgUserLicenseDetail -UserId awithenshaw@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\awithenshaw-license.csv
Get-MgUserLicenseDetail -UserId jleibel@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\jleibel-license.csv
Get-MgUserLicenseDetail -UserId efong@pursuitcollection.com | Export-CSV V:\IT\MS-Licensing\efong-license.csv
