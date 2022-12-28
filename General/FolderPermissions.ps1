# get-acl -Path | fl "location"

# CACLS remove all permissions and assign FULL to everyone
cacls "path" /T /G "everyone":F

# Example
Get-Acl -Path "\\usak06-fs01.ges.intra\Shared\081220_AlaskaBoat" | fl > "C:\_Workfile\Temp\081220_AlaskaBoat.txt"
