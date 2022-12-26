$idracip = Read-Host -Prompt "Enter IP Address of CMC to Configure: "

$VSSPass = Read-Host -Prompt "Enter Password for vssadmin"
$VSSPass2 = Read-Host -Prompt "Verify Password for vssadmin"

$Pass = $VSSPass.CompareTo($VSSPass2)

If ($Pass -eq 0)
{

	#Setup AD Integration

    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADEnable 1
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADType 2
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 1 -o cfgSSADRoleGroupName RG-IDRAC-Server-Administrators
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 1 -o cfgSSADRoleGroupDomain ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 1 -o cfgSSADRoleGroupPrivilege 0x00000fff
	racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 2 -o cfgSSADRoleGroupName RG-IDRAC-Pursuit-Server-Administrators
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 2 -o cfgSSADRoleGroupDomain ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 2 -o cfgSSADRoleGroupPrivilege 0x00000fff
	racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 3 -o cfgSSADRoleGroupName RG-IDRAC-Pursuit-Server-OnCall
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 3 -o cfgSSADRoleGroupDomain ges.intra
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgStandardSchema -i 3 -o cfgSSADRoleGroupPrivilege 0x000000f9
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADDomainController1 10.111.192.87
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADDomainController2 10.111.192.88
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADGlobalCatalog1 10.111.192.87
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADGlobalCatalog2 10.111.192.88
    racadm -r $idracip -u vssadmin -p $VSSPass --nocertwarn config -g cfgActiveDirectory -o cfgADCertValidationEnable 0

}

Else {
Write-Host "vssadmin passwords Do Not Match"
}