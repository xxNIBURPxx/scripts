#If file size exceeds x then kill retail pro, remove tr.dat file and copy original
taskkill /IM rpro9.exe /f
taskkill /IM vIQing4TR.exe /f
$data=Get-Item -path C:\RIQ\vIQing\CreditCard\tr.dat | Where-Object  {
    ($_.Length /1GB) -gt '1'
    }

    If($data){
    Remove-Item "$data"
    }
xcopy "C:\RIQ\tr.dat" C:\RIQ\vIQing\CreditCard\ /y
shutdown -r -t 00
