taskkill /IM RTPOne.exe /f
taskkill /IM RTPONEContainer.exe /f
timeout /t 10
cd "C:\Program Files (x86)\RTP\RTPOne\"
.\RTPOne.exe
