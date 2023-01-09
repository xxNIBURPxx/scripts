# Get AD user when created filtered by event 4720
$Report = @()
$time = (get-date) - (new-timespan -hour 24)
$AllDCs = Get-ADDomainController -Filter *
ForEach($DC in $AllDCs)
{
Get-WinEvent -ComputerName $dc.Name -FilterHashtable @{LogName="Security";ID=4720;StartTime=$Time}| Foreach {
$event = [xml]$_.ToXml()
if($event)
{
$Time = Get-Date $_.TimeCreated -UFormat "%Y-%m-%d %H:%M:%S"
$CreatorUser = $event.Event.EventData.Data[4]."#text"
$NewUser = $event.Event.EventData.Data[0]."#text"
$objReport = [PSCustomObject]@{
User = $NewUser
Creator = $CreatorUser
DC = $event.Event.System.computer
CreationDate = $Time
}
}
$Report += $objReport
}
}
$Report

# Get ADUser
Get-ADUser prubin –properties name,whencreated,whocreated|select name,whencreated,whocreated

# Get ADUsers created
$lastday = ((Get-Date).AddDays(120))
$filename = Get-Date -Format yyyy.MM.dd
$exportcsv=”c:\temp\new_ad_users_” + $filename + “.csv”
Get-ADUser -filter {(whencreated -ge $lastday)} –properties whencreated | Select-Object Name, UserPrincipalName, SamAccountName, whencreated | Export-csv -path $exportcsv
