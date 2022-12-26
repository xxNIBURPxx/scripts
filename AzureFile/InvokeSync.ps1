#Connect to Azure
Connect-AzAccount
#set subscription
#Dev
Set-AzContext -Subscription '1854b75f-ca5d-4b38-9bf1-4d4c5a5bbf3e'
#Prod
Set-AzContext -Subscription '06f1eead-10df-4692-b45f-5c6309c40940'

Invoke-AzStorageSyncChangeDetection -ResourceGroupName "pursuit-azfileshare" -StorageSyncServiceName "pursuitazfilesync" -SyncGroupName "cresfs02azfs01" -CloudEndpointName "ccee0606-786b-4ba7-bed7-76e8327f8a7e" -Path "Data"

/subscriptions/06f1eead-10df-4692-b45f-5c6309c40940/resourceGroups/pursuit-azfileshare/providers/Microsoft.StorageSync/storageSyncServices/pursuitazfilesync/syncGroups/cresfs02azfs01/cloudEndpoints/ccee0606-786b-4ba7-bed7-76e8327f8a7e