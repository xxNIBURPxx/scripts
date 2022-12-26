#connect azure ad
Connect-AzAccount

#get az resource Azure cloud console
Get-AzureRmResource | Export-CSV pursuit-resources.csv

#set subscription
#Dev
Set-AzContext -Subscription '1854b75f-ca5d-4b38-9bf1-4d4c5a5bbf3e'
#Prod
Set-AzContext -Subscription '06f1eead-10df-4692-b45f-5c6309c40940'


#set az resource
Set-AzResource -ResourceId "/subscriptions/5015af9f-105e-442b-b7bd-fd628d2e87ac/resourceGroups/niburp-web" -Tag @{"Resource Type"="Storage Account"; "Category"="Web"; "Resource"="Group"} -Force
