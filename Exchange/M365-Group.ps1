#Connect exchange online
Connect-ExchangeOnline

#Get
Get-UnifiedGroup PursuitPowerBIComboRedemptionsBJC

#Add
Set-UnifiedGroup PursuitPowerBIComboRedemptionsBJC -EmailAddresses @{add="PursuitPowerBIComboRedemptionsBJC@pursuitcollection.com"}

#Remove
Set-UnifiedGroup Group1 -EmailAddresses @{remove="group1@secondary.contoso.com"}

#Set primary SmtpAddress
Set-UnifiedGroup -Identity "PursuitPowerBIComboRedemptionsBJC" -PrimarySmtpAddress PursuitPowerBIComboRedemptionsBJC@pursuitcollection.com -RequireSenderAuthenticationEnabled $false