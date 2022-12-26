#connect to azure ad
Connect-AzureAD

#get device registration
Get-Win10IntuneManagedDevice -deviceName “USNV09-19WM9G3”