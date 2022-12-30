#Map drive for Azure File
$connectTestResult = Test-NetConnection -ComputerName niburp.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"niburp.file.core.windows.net`" /user:`"localhost\niburp`" /pass:`"z3mJoGrD6CfGMdKbHPVDJnbaud0o6t0uniZ3XLdd877qQ4IDP8QMdzT7AMCG5n/UtTo9kSbQoBjk+AStdg5ZkA==`""
    # Mount the drive
    New-PSDrive -Name Y -PSProvider FileSystem -Root "\\niburp.file.core.windows.net\niburp" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}

#Azure file
robocopy "F:\PersonalFiles" "P:\PersonalFiles" /XO /E *.* /MAXAGE:20221230 /XO /E

#USB usbshare2
robocopy "M:\Movies" "X:\Movies" *.* /MAXAGE:20221227 /XO /E

#USB usbshare1-2
robocopy "M:\Movies" "Z:\Movies" *.* /MAXAGE:20221227 /XO /E

#USB external WD
robocopy "M:\Movies" "E:\Movies" *.* /MAXAGE:20221230 /XO /E
robocopy "P:\PersonalFiles" "E:\Data\PersonalFiles" *.* /MAXAGE:20221230 /XO /E
robocopy "P:\OneDrive" "E:\Data\OneDrive" *.* /MAXAGE:20221230 /XO /E
robocopy "S:\Software" "E:\Software" *.* /MAXAGE:20221230 /XO /E
