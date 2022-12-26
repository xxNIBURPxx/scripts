#Set OOO for O365 account
Connect-ExchangeOnline
Set-MailboxAutoReplyConfiguration -Identity name@pursuitcollection.com -AutoReplyState Enabled -InternalMessage "" -ExternalMessage ""