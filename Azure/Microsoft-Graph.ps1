#Install Microsoft Graph Module

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph -Scope AllUsers

#Connect to MS Graph
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"
Connect-Graph -Scopes Organization.Read.All

#Log out / disconnect
Disconnect-MgGraph

#Get management users
Get-MgUser

#Get SKUs
Get-MgSubscribedSku | Select -Property Sku*, ConsumedUnits -ExpandProperty PrepaidUnits | Format-List