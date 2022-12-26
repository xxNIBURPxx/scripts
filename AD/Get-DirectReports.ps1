#Get direct reprts in AD
Get-ADUser -Identity blutz -Properties directreports  -Server caab01-prstdc01.pursuit.intra | select-object -ExpandProperty directreports > report-blutz-reports.csv

