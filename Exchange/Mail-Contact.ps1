#FOLV Distributions: FOLV-GuestExperienceGuides, FOLV-FoodAndBeverage

Connect-ExchangeOnline

#new mail contact
New-MailContact -Name "First Last" -ExternalEmailAddress "email@domain.com"
Add-DistributionGroupMember -Identity "folv-leads@flyoverlasvegas.com" -Member "tdukes"

#Run Get-DistributionGroupMember below to get alias if necessary

Get-DistributionGroupMember -Identity "Group Name"
Remove-DistributionGroupMember -Identity "FOLV-GuestExperienceGuides" -Member "nmaldonado-p"
Remove-MailContact -Identity "nmaldonado-p"
Get-MailContact -Identity "Noelia Guilfuchi Maldonado"

#Copy paste from above to reuse
New-MailContact -Name "Blade Ohman1" -ExternalEmailAddress "Jackieboy965251@yahoo.com"
Add-DistributionGroupMember -Identity "FOLV-FoodAndBeverage" -Member "BladeOhman1"
Get-DistributionGroupMember -Identity "FOLV-GuestExperienceGuides" > geg.txt

#New mail contact local exchange
New-MailContact -Name "SmartConnect RetProAPGPI" -ExternalEmailAddress "SmartConnectRetproAPGPINotification@pursuitcollection.com"
