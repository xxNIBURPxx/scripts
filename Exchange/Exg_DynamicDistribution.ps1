#get/add dynamic exg groups
Get-DynamicDistributionGroup -Identity "Broadcast - Pursuit - FlyOver Las Vegas - All Teams" |fl RecipientFilter
Get-DynamicDistributionGroup -Identity "Broadcast - Pursuit - FlyOver Iceland - All Teams" |fl RecipientFilter
Get-DynamicDistributionGroup -Identity "Broadcast - Pursuit - FlyOver Canada - All Teams" |fl RecipientFilter
Get-DynamicDistributionGroup -Identity "Broadcast - Pursuit - FlyOver Chicago - All Teams" |fl RecipientFilter

Broadcast-Pursuit-FlyOver_Chicago-All_Teams@pursuitcollection.com

Get-DynamicDistributionGroupMember -Identity "Broadcast - Pursuit - FlyOver Canada - All Team"
Get-DynamicDistributionGroupMember -Identity "Broadcast - Pursuit - FlyOver Las Vegas - All Teams"
Get-DynamicDistributionGroupMember -Identity "Broadcast - Pursuit - FlyOver Chicago - All Teams"