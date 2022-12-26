$connectTestResult = Test-NetConnection -ComputerName niburp.file.core.windows.net -Port 445
if ($connectTestResult.TcpTestSucceeded) {
    # Save the password so the drive will persist on reboot
    cmd.exe /C "cmdkey /add:`"niburp.file.core.windows.net`" /user:`"localhost\niburp`" /pass:`"/nb9GO23m6bsBmhHOVkmbYWxtu5qzr1XjK+JI2qYd5F48I3fSyz7UvMxBSwTgUKW5wsLn3ongBvh+ASthSb7zg==`""
    # Mount the drive
    New-PSDrive -Name Y -PSProvider FileSystem -Root "\\niburp.file.core.windows.net\niburp" -Persist
} else {
    Write-Error -Message "Unable to reach the Azure storage account via port 445. Check to make sure your organization or ISP is not blocking port 445, or use Azure P2S VPN, Azure S2S VPN, or Express Route to tunnel SMB traffic over a different port."
}