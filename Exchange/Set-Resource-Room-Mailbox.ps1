#Connect to exchange online
Connect-ExchangeOnline

#Set False
Get-Mailbox Sky-Lagoon-Meeting-Room-1-Exhale@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$False -AllRequestInPolicy:$False
Get-Mailbox Sky-Lagoon-Meeting-Room-2-Inhale@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$False -AllRequestInPolicy:$False
Get-Mailbox Sky-Lagoon-Meeting-Room-3-Focus@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$False -AllRequestInPolicy:$False

#Set True
Get-Mailbox Sky-Lagoon-Meeting-Room-1-Exhale@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$True -AllRequestInPolicy:$True
Get-Mailbox Sky-Lagoon-Meeting-Room-2-Inhale@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$True -AllRequestInPolicy:$True
Get-Mailbox Sky-Lagoon-Meeting-Room-3-Focus@skylagoon.is | Set-CalendarProcessing -AllBookInPolicy:$True -AllRequestInPolicy:$True