#Get AD user
get-aduser -server pursuit.intra prubin

#Get AD users in OU
get-aduser -Filter * -SearchBase 'OU=CABC05,OU=FlyOver Canada,OU=_Users,DC=pursuit,DC=intra' -Server pursuit.intra | Export-CSV c:\temp\cabc05-users.csv

get-aduser -Filter * -SearchBase 'OU=USCO03,OU=Pursuit,OU=_Users,DC=pursuit,DC=intra' -Server pursuit.intra > c:\temp\usco03-users.txt

get-aduser -Filter * -SearchBase 'OU=USCO05,OU=Pursuit,OU=_Users,DC=pursuit,DC=intra' -Server pursuit.intra | Export-CSV c:\temp\usco05-users.csv

#Set AD user office name
set-aduser 'CN=Effinger\, Donte,OU=USNV09,OU=FlyOver Las Vegas,OU=_Users,DC=pursuit,DC=intra' -Server pursuit.intra -Replace @{physicalDeliveryOfficeName="USNV09 - FlyOver Las Vegas"}
