# This script uses hard coded variables, please ensure the variables in the initialization section are set before execution
# Once you start the execution you will be prompted to sign into your Office 365 Account

###########################################################################################################
#                                         Initialization
###########################################################################################################

#---------------------------------------------------------------------------------
# invitationsPath is the path to the invitation csv example: 'C:\temp\ivitation.csv'
#---------------------------------------------------------------------------------
$invitationsPath = 'C:\temp\ivitation.csv'

#---------------------------------------------------------------------------------
# messageBody is the body of the message that will be sent on the invitation
#---------------------------------------------------------------------------------
$messageBody = "You've been invited as a guest user to collaborate on the pursuit intranet sharepoint group with Pursuit."

#---------------------------------------------------------------------------------
# internalDomains is a list a list of domains for emails that may already exist on the AD tenant
#---------------------------------------------------------------------------------
$internalDomains = (
    "apgarvillage.com",
    "banffgondola.com",
    "beltonchalet.com",
    "brewsterexpress.com",
    "brewstersightseeing.com",
    "chateaujasper.com",
    "crimsonjasper.com",
    "denalibackcountryadventure.com",
    "denalibackcountrylodge.com",
    "denali-cabins.com",
    "elkandavenue.com",
    "explorerockies.com",
    "flyovercanada.com",
    "flyovericeland.com",
    "flyovericeland.is",
    "flyoverlasvegas.com",
    "glacier-adventure.com",
    "glacierbasecamplodge.com",
    "glacierparklodge.com",
    "glacierskywalk.com",
    "glacierviewinn.com",
    "grousemountainlodge.com",
    "kenaifjordslodge.com",
    "kenaifjordstours.com",
    "lobsticklodge.com",
    "malignecanyon.com",
    "malignelake.com",
    "minnewanka.com",
    "mountroyalhotel.com",
    "marmotlodge.com",
    "pocahontasjasper.com",
    "pyramidlakejasper.com",
    "princeofswaleswaterton.com",
    "pursuitcollection.com",
    "sawridgeinn.com",
    "sewardwindsonglodge.com",
    "skylagoon.com",
    "skylagoon.is",
    "stmaryvillage.com",
    "talkeetnaalaskanlodge.com",
    "toquepub.com",
    "westglacier.com")


#---------------------------------------------------------------------------------
# url of the targeted sharepoint site
#---------------------------------------------------------------------------------
$url = https://viadcorp.sharepoint.com/sites/pursuitintranet

#---------------------------------------------------------------------------------
#  Groups is a list of strings containing the guids of the groups the newly invited users need to be a part of example 'a15e5963-0367-4941-a927-811c978b1d37'
#---------------------------------------------------------------------------------
$groups = @('a15e5963-0367-4941-a927-811c978b1d37')

#---------------------------------------------------------------------------------
#  Codes are the 
#---------------------------------------------------------------------------------
$Codes = @("ESPT", "ESFT", "SEFT", "SEPT", "INVITE", "SL")

#---------------------------------------------------------------------------------
#  logFilePath, destination of the log file example "C:\Temp"
#---------------------------------------------------------------------------------

$logFilePath = "C:\Temp"


###########################################################################################################
#                                         Code Execution
###########################################################################################################

Connect-AzureAD

$invitations = Import-Csv $invitationsPath


$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo
$messageInfo.customizedMessageBody = $messageBody


$dateString = Get-Date -Format "MMddyyyyHHmmfff"

New-Item -Path $logFilePath -Name "InviteLog_$($dateString).txt" -ItemType "file"

$fileName = "$($logFilePath)\InviteLog_$($dateString).txt"


foreach ($email in $invitations) {
    if($email.'In AD' -eq $null -or $email.'In AD' -eq "")
    {
            $userSkippedMessage = "Information: $($email.'First Name') $($email.'Last Name') has been skipped as it is unknown if they are in ad or not"
            Write-Host $userAddedToGroupMessage
            Add-Content -Path $fileName -Value $userAddedToGroupMessage

    }
    elseif($email.'In AD' -eq "N")
    {
        if($codes -contains $email.'Worker Category Code')
        { 
            $emailToUse = ""
            $userFound = $false
            $personalEmailExists = $false
            $workEmailExists = $false

            $existingEmail = ""

            if($email.'Personal Email' -ne $null -and $email.'Personal Email' -ne "){
                $personalEmailExists = $true
                $emailToUse = $email.'Personal Email'
                $personalEmail = $email.'Personal Email'.Replace("@,"_") + #EXT#@pursuitcollection.com
                $inviteEmail = $personalEmail
                try{
                    $user = Get-AzureADUser -ObjectId $personalEmail
                    if($user -ne $null){
                        $userFound = $true
                        $existingEmail = $email.'Personal Email'
                        $userId = $user.ObjectId
                    }
                }
                catch{
                    $user = $null
                }
            }

            if($email.'Work Email' -ne $null -and $email.'Work Email' -ne "){
                $workEmailExists = $true
                if(!$personalEmailExists){
                    $emailToUse = $email.'Work Email'
                }
                $workEmail = $email.'Work Email'.Replace("@,"_") + #EXT#@pursuitcollection.com



                if(!$userFound){
                    try{
                        $user = Get-AzureADUser -ObjectId $workEmail
                        if($user -ne $null){
                            $userFound = $true
                            $emailExists = $true
                            $userId = $user.ObjectId
                        }
                    }
                    catch{
                        $user = $null
                    }

                    if($user -eq $null -and !$userFound){
                        foreach($internalDomain in $internalDomains)
                        {
                            $workEmailExists = $email.'Work Email' -Match $internalDomain
                            $inviteEmail = $workEmail
                        }
                    }

                }
            }
    
            Write-Output "Work Exists: $($workEmailExists), Personal Exists: $($personalEmailExists)"

            $emailExists = $personalEmailExists -or $workEmailExists

            if($emailExists){
                if($userFound){
                    $userExistsMessage = "Warning: $($email.'First Name') $($email.'Last Name') with email $($existingEmail) already exists"
                    Write-Output $userExistsMessage
                    Add-Content -Path $fileName -Value $userExistsMessage

                       foreach ($group in $groups) {
                        try {
                               Add-AzureADGroupMember -ObjectId $group -RefObjectId $userId
                            $userAddedToGroupMessage = "Information: $($email.'First Name') $($email.'Last Name') has been added to group $($group)"
                            Write-Host $userAddedToGroupMessage
                            Add-Content -Path $fileName -Value $userAddedToGroupMessage

                        }
                        catch {
                            $ErrorMessage = $_.Exception.Message
                            $error = "Error: Could not add group to $($email.'First Name') $($email.'Last Name') Error Message: $($ErrorMessage) "
                            Write-Host $error
                            Add-Content -Path $fileName -Value $error
                        }
                       }
                }
                else{
                    $response = New-AzureADMSInvitation `
                                 -InvitedUserEmailAddress $emailToUse `
                                 -InvitedUserDisplayName $email.Name `
                                 -InviteRedirectUrl $url `
                                 -InvitedUserMessageInfo $messageInfo `
                                 -SendInvitationMessage $true
                          $userInvitedMessage = "Information: $($email.'First Name') $($email.'Last Name') with email $($emailToUse) was invited "
                          Write-Host $userInvitedMessage
                    Add-Content -Path $fileName -Value $userInvitedMessage

        

                       foreach ($group in $groups) {
                        try {
                               Add-AzureADGroupMember -ObjectId $group -RefObjectId $response.InvitedUser.Id
                            $userAddedToGroupMessage = "Information: $($email.'First Name') $($email.'Last Name') has been added to group $($group)"
                            Write-Host $userAddedToGroupMessage
                            Add-Content -Path $fileName -Value $userAddedToGroupMessage
                        }
                           catch{
                            $ErrorMessage = $_.Exception.Message
                            $error = "Error: Could not add group to $($email.'First Name') $($email.'Last Name') Error Message: $($ErrorMessage) "
                            Write-Host $error
                            Add-Content -Path $fileName -Value $error
                        }
            
                       }
                }
            }
                     else{
                           $personal = $email.'Personal Email'
                           $work = $email.'Work Email'
                           $message = "Warning: Neither the Personal Email: ""$($personal)"" nor the Work email: ""$($work)"" for $($email.'First Name') $($email.'Last Name') exist"
                           $message
                           Add-Content -Path $fileName -Value $message
                     }
              }
              else{
                     $userSkippedMessage = "Information: $($email.'First Name') $($email.'Last Name') has been skipped user code ignored"
            Write-Host $userSkippedMessage
            Add-Content -Path $fileName -Value $userSkippedMessage
              }
    }
    elseif($email.'In AD' -eq "Y")
    {
            $userSkippedMessage = "Information: $($email.'First Name') $($email.'Last Name') has been skipped as they already exist in AD"
            Write-Host $userSkippedMessage
            Add-Content -Path $fileName -Value $userSkippedMessage
    }
} 

