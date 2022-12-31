#Join AZ Storage account. Update: resource group name, storage account name based on needs
Connect-AzAccount
#set subscription
#Dev
Set-AzContext -Subscription '1854b75f-ca5d-4b38-9bf1-4d4c5a5bbf3e'
#Prod
Set-AzContext -Subscription '06f1eead-10df-4692-b45f-5c6309c40940'

Join-AzStorageAccount -ResourceGroupName "niburp" -StorageAccountName "niburp" -Domain "niburp.local" -DomainAccountType ComputerAccount -OrganizationalUnitDistinguishedName "OU=_StorageAccounts,DC=niburp,DC=local"