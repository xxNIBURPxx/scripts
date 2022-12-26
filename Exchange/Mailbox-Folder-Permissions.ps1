#get mailbox folder permissions
Get-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com

#add mailbox folder permissions
Add-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User adonahe@pursuitcollection.com -AccessRights Owner
Add-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User anicolet@pursuitcollection.com -AccessRights Owner
Add-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User mbenware@pursuitcollection.com -AccessRights Owner
Add-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User JenniferH@pursuitcollection.com -AccessRights Owner
Add-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User lharrington@pursuitcollection.com -AccessRights Owner

#remove mailbox folder permissions
Remove-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User adonahe@pursuitcollection.com
Remove-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User anicolet@pursuitcollection.com
Remove-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User mbenware@pursuitcollection.com
Remove-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User JenniferH@pursuitcollection.com
Remove-MailboxFolderPermission -Identity Alaskagroupsales@pursuitcollection.com -User lharrington@pursuitcollection.com

#get mailbox folder statistics
Get-MailboxFolderStatistics Alaskagroupsales@pursuitcollection | Export-CSV c:\temp\folders.csv
Get-MailboxFolder -Identity Alaskagroupsales@pursuitcollection

#get mailbox permissions
Get-MailboxPermission -Identity Alaskagroupsales@pursuitcollection.com

#add mailbox permission
Add-MailboxPermission -Identity Alaskagroupsales@pursuitcollection.com -User adonahe@pursuitcollection.com -AccessRights Owner
