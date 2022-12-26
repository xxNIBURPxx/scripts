##Stop EcmExchange20000 Service
Stop-Service -Name "EcmExchange20000"

##Timout delay
timeout /T 10

##Clean logs
D:
cd D:\ECM\Polling\Log\EcmExchange\
Rename-Item -Path "Log.DAT" -NewName "Log.OLD"
Rename-Item -Path "Log.IX" -NewName "Log.IXOLD"
Rename-Item -Path "Log.DIA" -NewName "Log.DIAOLD"
Get-Item "D:\ECM\Polling\Log\EcmExchange\Log.OLD" | Move-Item -Destination "D:\ECM\Polling\Log\EcmExchange\OLD\"
Get-Item "D:\ECM\Polling\Log\EcmExchange\Log.IXOLD" | Move-Item -Destination "D:\ECM\Polling\Log\EcmExchange\OLD\"
Get-Item "D:\ECM\Polling\Log\EcmExchange\Log.DIAOLD" | Move-Item -Destination "D:\ECM\Polling\Log\EcmExchange\OLD\"

##Delete files
cd D:\ECM\Polling\Log\EcmExchange\OLD\
del Log.OLD
del Log.IXOLD
del Log.DIAOLD

##Start EcmExchange20000 Service
Start-Service -Name "EcmExchange20000"
