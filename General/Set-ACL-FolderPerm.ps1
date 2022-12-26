$folderPath = "D:\Data\Share\COMMON\TPC 2019"

$user = "ges\RG-FileServer-Administrators"

$accesstype = "FullControl"

$allowOrDeny = "Allow"

$argList = $user,$accesstype,$allowOrDeny

$acl = Get-Acl $folderPath

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $argList

$acl.SetAccessRule($AccessRule)

$acl | Set-acl $folderPath

##next entry##

$folderPath = "D:\Data\Share\COMMON\TPC 2019"

$user = "ges\RG-HelpDesk"

$accesstype = "FullControl"

$allowOrDeny = "Allow"

$argList = $user,$accesstype,$allowOrDeny

$acl = Get-Acl $folderPath

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $argList

$acl.SetAccessRule($AccessRule)

$acl | Set-acl $folderPath

##next entry##
$folderPath = "D:\Data\Share\COMMON\TPC 2019"

$user = "ges\RG-HelpDesk"

$accesstype = "FullControl"

$allowOrDeny = "Allow"

$argList = $user,$accesstype,$allowOrDeny

$acl = Get-Acl $folderPath

$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule -ArgumentList $argList

$acl.SetAccessRule($AccessRule)

$acl | Set-acl $folderPath