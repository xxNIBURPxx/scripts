#connect azure ad
Connect-AzAccount

$resourceGroupName = "pursuit-simphony-uscentral-prod-rg"
$storageAccountName = "simphonyexports"

Set-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName -EnableSftp $true