##Set Hostname
racadm set System.ServerOS.HostName usak05-esx02.ges.intra
##Set Server OS Name
racadm set System.ServerOS.OSName "name"
##Stop start lifecycle controller
#off
racadm set LifecycleController.LCAttributes.LifecycleControllerState 0
#on
racadm set LifecycleController.LCAttributes.LifecycleControllerState 1

#Check power status
racadm serveraction -m server-1 powerstatus

#Reseat blade
racadm serveraction -m server-1 reseat -f

#Power up blade
racadm serveraction -m server-1 powerup

#Power down blade
racadm serveraction -m server-1 powerup
