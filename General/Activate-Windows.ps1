# Change product key to enterprise MAK
    Changepk.exe /ProductKey:8VFTX-MN3X8-DMBDG-B3KQC-3YH2F
# Activate product key
    slmgr.vbs /ipk 8VFTX-MN3X8-DMBDG-B3KQC-3YH2F
# Pause for activation
    TIMEOUT /T 15
# Shutdown Servicehost
    taskkill.exe /im "Servicehost.exe" /f
# Reboot workstation
    shutdown -r -t 01
