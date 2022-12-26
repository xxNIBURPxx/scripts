Get-CimInstance -ClassName Win32_OperatingSystem | select CsName, lastbootuptime
Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName "dc02" | select CsName, lastbootuptime