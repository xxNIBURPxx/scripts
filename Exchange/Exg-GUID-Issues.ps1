# Get recipient by GUID soft deleted account
Get-Recipient -IncludeSoftDeletedRecipients "1d6bbd10-9583-4805-b2fc-f7ab24b5db34" |fl RecipientType,PrimarySmtpAddress,*WhenSoftDeleted*
