#Get current logged on user
$Loggedon = Get-WmiObject -ComputerName caab41-retsrv01.ges.intra -Class Win32_Computersystem | Select-Object UserName