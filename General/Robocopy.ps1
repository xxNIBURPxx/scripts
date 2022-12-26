#Robocopy changed files maxage

Robocopy D:\Data\Shared01\Departments\ \\caab01-fs02\d$\Data\Share\Departments\ *.* /MAXAGE:20220722 /XO /E
Robocopy D:\Data\Shared01\COMMON\ \\caab01-fs02\d$\Data\Share\COMMON\ *.* /MAXAGE:20220722 /XO /E

Robocopy "X:\COMMON\Gateway Cash Reports\Maestro" Z:\maestro\ *.* /MAXAGE:20220803

robocopy "P:\Nextcloud\prubin\files\Documents" "Y:\backup\Documents" *.* /MAXAGE:20220805 /XO /E
robocopy "P:\Nextcloud\prubin\files\Photos" "Y:\backup\Photos" *.* /MAXAGE:20220806 /XO /E
robocopy "P:\Nextcloud\prubin\files\Videos" "Y:\backup\Videos" *.* /MAXAGE:20220806 /XO /E
robocopy "P:\Nextcloud\prubin\files\Documents\Tech\Scripts\Scripts" "P:\OneDrive\Documents\GitHub\Scripts\Scripts" *.* /MAXAGE:20220805