#Hide address from GAL

Connect-ExchangeOnline

Set-Mailbox -Identity khunt@pursuitcollection.com -HiddenFromAddressListsEnabled $false