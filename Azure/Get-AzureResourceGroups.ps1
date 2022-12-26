#Get Azure resource groups and tags

#set subscription
#Dev
Set-AzContext -Subscription '1854b75f-ca5d-4b38-9bf1-4d4c5a5bbf3e'
#Prod
Set-AzContext -Subscription '06f1eead-10df-4692-b45f-5c6309c40940'

#Get Azure resource groups and tags
Get-AzResourceGroup -Tag @{'CompanyName'='Pursuit'} | Export-CSV resource_groups_01.csv