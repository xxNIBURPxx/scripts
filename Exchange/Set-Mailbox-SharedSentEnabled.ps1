#Connect exchange online
Connect-ExchangeOnline

#Set shared mailbox sent items enabed $True
Set-Mailbox info@skylagoon.is -MessageCopyForSentAsEnabled $True
Set-Mailbox info@skylagoon.is -MessageCopyForSendOnBehalfEnabled $True