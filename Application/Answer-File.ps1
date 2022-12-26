setup.exe -r -f1C:\temp\setup.iss

mkdir c:\_temp
xcopy INSTALL.iss "c:\_temp" /y
xcopy UNINSTALL.iss "c:\_temp" /y
rpro9_setup.exe /S /f1"C:\_temp\INSTALL.iss"
powershell.exe -ExecutionPolicy Bypass -File .\RetailPro_Folder_Permissions.ps1
powershell.exe -ExecutionPolicy Bypass -File .\Oracle_Folder_Permissions.ps1
xcopy "Retail Pro 9 Launcher.lnk" "%PUBLIC%\Desktop\" /y
xcopy "%public%\desktop\Retail Pro 9 Launcher.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RetailPro9\" /y
del "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\RetailPro9\Rpro9 Launcher.lnk"
shutdown -r -t 10
