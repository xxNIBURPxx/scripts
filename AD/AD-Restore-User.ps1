## Gather AD Users last Name to search for
Write-Host "This script will restore a single searched object by entering the users Last Name and selecting it in Out-Gridview" -ForegroundColor Red -BackgroundColor Black
Write-Host "------------------------------------------------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
Write-Host "Or allow you to search and select multiple objects in Out-Gridview" -ForegroundColor Red -BackgroundColor Black
Write-Host "------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
Write-Host "Enter the Last Name of the user OR Click enter to see all deleted objects" -ForegroundColor Red -BackgroundColor Black
Write-Host "-------------------------------------------------------------------------" -BackgroundColor Black -ForegroundColor White
$search = Read-Host " "
$datas = Get-ADObject -LDAPFilter:"(msDS-LastKnownRDN=*)" -IncludeDeletedObjects | where DistinguishedName -like "*$search*" | Out-GridView -OutputMode Multiple
Foreach ($data in $datas) {
    Restore-ADObject -Identity "$($data.ObjectGUID)" -Server "usnv01-gesdc01.ges.intra"
    $res = get-aduser -Identity "$($data.ObjectGUID)"
    Write-host "$($res.Name)" -ForegroundColor Green -BackgroundColor Black
}
Write-Host "`nPerforming AD Sync Cycle ..." -ForegroundColor Yellow
$results = Invoke-Command -ComputerName  "usnv01-adcon02.ges.intra" -ScriptBlock {
    
    # Performing Sync
    Do {
        Write-Host "Performing Delta Sync" -ForegroundColor Yellow -NoNewline
        Try {
            Start-ADSyncSyncCycle -PolicyType Delta
            Write-Host " ... success!" -ForegroundColor Green
            $SyncSuccess = 1
        }
        Catch {
            Write-Host " ... sync in progress, waiting!" -ForegroundColor Red
            Start-Sleep -Seconds 20
            $SyncSuccess = 0
        } 
    } Until ($SyncSuccess -eq 1)
    # Forcing sleep to give AD Sync time to begin
    Start-Sleep -Seconds 20
    
    # Hold until finished sync cycle
    Do {
        Write-Host "Waiting for sync to finish, please wait" -ForegroundColor Yellow -NoNewline
        If ((Get-ADSyncConnectorRunStatus).RunState -eq "Busy") 
        { Write-Host " ... sync in progess, waiting!" -ForegroundColor Red; Start-Sleep -Seconds 20; $SyncSuccess = 0 }
        Else
        { Write-Host " ... success!" -ForegroundColor Green; $SyncSuccess = 1 }
    } Until ($SyncSuccess -eq 1)
}