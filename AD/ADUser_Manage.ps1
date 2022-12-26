#search ad account locked out status
#GES domain
search-adaccount -LockedOut
#Pursuit domain controller
search-adaccount -LockedOut -Server caab01-prstdc01.pursuit.intra

#unlock ad user account
Unlock-ADAccount -Server caab01-prstdc01.pursuit.intra -Identity kgadberry
Unlock-ADAccount -Identity karikrishnan

#get ad user properties
get-aduser -Server caab01-prstdc01.pursuit.intra -Identity "jonunez" -Properties * | Export-CSV jonunez.csv
get-aduser -Server caab01-prstdc01.pursuit.intra -Identity "askivington" -Properties *
get-aduser -Identity "plr" -Properties *
get-aduser -Identity "hhv"

#get adgroup
Get-ADGroupMember -Server caab01-prstdc01.pursuit.intra -Identity "FS-CAAB01 Shared" > fs-caab01shared.txt| Export-CSV FS-CAAB01-Shared.csv
Get-ADGroupMember -Server caab01-prstdc01.pursuit.intra -Identity "FS-CAAB01 Pursuit Sales" > fs-caab01-pursuit-sales.txt
Add-ADGroupMember -Server caab01-prstdc01.pursuit.intra -Identity "FS-CAAB01 Pursuit Sales" mbamberry