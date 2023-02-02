# Get recipient by GUID soft deleted account
Get-Recipient -IncludeSoftDeletedRecipients "1d6bbd10-9583-4805-b2fc-f7ab24b5db34" |fl RecipientType,PrimarySmtpAddress,*WhenSoftDeleted*
bberg@viadcorp.onmicrosoft.com

# Get exchange user issues
(Get-MsolUser -UserPrincipalName bberg@pursuitcollection.com).errors.errordetail.objecterrors.errorrecord| fl

# Get soft deleted users
Get-Recipient -IncludeSoftDeletedRecipients "1d6bbd10-9583-4805-b2fc-f7ab24b5db34" |ft RecipientType,PrimarySmtpAddress,*WhenSoftDeleted*

# Purge
Remove-Mailbox "1d6bbd10-9583-4805-b2fc-f7ab24b5db34" -PermanentlyDelete

# Undo/Reconnect
Undo-SoftDeletedMailbox -SoftDeletedObject 1d6bbd10-9583-4805-b2fc-f7ab24b5db34 -WindowsLiveID bberg@viadcorp.onmicrosoft.com -Password (ConvertTo-SecureString -String 'Pa$$word1' -AsPlainText -Force)

# Get User issues
Get-MsolUser-HasErrorsOnly|flDisplayName,UserPrincipalName,@{Name=”Error”;Expression={($_.errors[0].ErrorDetail.objecterrors.errorrecord.ErrorDescription)}}

# Get mailboxs with holds
Get-Mailbox 1d6bbd10-9583-4805-b2fc-f7ab24b5db34 | FL LitigationHoldEnabled,InPlaceHolds

# Get inactive mailbox
Get-Mailbox -InactiveMailboxOnly | Format-List Name,DistinguishedName,ExchangeGuid,PrimarySmtpAddress

# Remove msoluser
Remove-MsolUser -UserPrincipalName "bberg@pursuitcollection.com"

# Remove msoluser from recycle bin
Remove-MsolUser -UserPrincipalName "bberg@pursuitcollection.com" -RemoveFromRecycleBin

# Undo soft deleted mailbox
Undo-SoftDeletedMailbox -SoftDeletedObject 1d6bbd10-9583-4805-b2fc-f7ab24b5db34
