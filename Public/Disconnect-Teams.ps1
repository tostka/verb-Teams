#*------v Disconnect-Teams.ps1 v------
Function Disconnect-Teams {
    <#
    .SYNOPSIS
    Disconnect-Teams - Echo's msg that Teams doesn't *support* disconnect cmdlet
    .NOTES
    Updated By: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    REVISIONS   :
    # 1:18 PM 11/7/2018 added Disconnect-PssBroken
    # 12:42 PM 6/20/2018 ported over from disconnect-exo
    .DESCRIPTION
    I use this to smoothly cleanup connections.
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Disconnect-Teams;
    .LINK
    https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    *---^ END Comment-based Help  ^--- #>
    # 9:25 AM 3/21/2017 getting undefined on the below, pretest them
    <#
    if($Global:TeamsModule){$Global:TeamsModule | Remove-Module -Force ; } ;
    if($Global:TeamsSession){$Global:TeamsSession | Remove-PSSession ; } ;
    # "https://ps.compliance.protection.outlook.com/powershell-liveid/" ; should still work below
    Get-PSSession | Where-Object {$_.ComputerName -like '*.outlook.com'} | Remove-PSSession ;
    Disconnect-PssBroken ;
    Remove-PSTitlebar 'Teams' ;
    #>
    #write-host -foregroundcolor green "(teams doesn't support a disconnect command)" ;
    # 12:45 PM 7/27/2021 it's listed now: https://docs.microsoft.com/en-us/powershell/module/teams/disconnect-microsoftteams?view=teams-ps
    [CmdletBinding()]
    [Alias('dtms')]
    Param() 
    $verbose = ($VerbosePreference -eq "Continue") ; 

    if(!(get-command -Name get-TeamHelp -ea 0)){
        Try { Get-Module MicrosoftTeams -ListAvailable -ErrorAction Stop | out-null } Catch {
            if(get-module PowerShellGet){ Install-Module MicrosoftTeams -scope CurrentUser }
            else { throw "REQUIRES WIN10, PSV5+ OR installed PowerShellGet module" } ;
        } ;
        Try {Get-Module MicrosoftTeams -ErrorAction Stop | out-null } Catch {Import-Module -Name MicrosoftTeams -ErrorAction Stop  } ;
        #if(!$MFA){ $Teamssplat.Add("Credential",$Credential) }
        #else { $Teamssplat.Add("AccountId",$Credential.username) }
        #write-verbose "(using cred:$($credential.username))" ; 
    } else { 
        #write-host -foregroundcolor yellow "(Teams already connected)" 
    } ;

     if(get-command Disconnect-MicrosoftTeams){
        $sTitleBarTag = @("TMS") ;
        $error.clear() ;
        try{
            #Disconnect-AzureAD -EA SilentlyContinue -ErrorVariable AADError ;
            Disconnect-MicrosoftTeams -EA SilentlyContinue -ErrorVariable TMSError  -verbose:$($verbose) ;
            Write-Host -ForegroundColor green ("MicrosoftTeams - Disconnected") ;
            remove-PSTitleBar $sTitleBarTag -verbose:$($VerbosePreference -eq "Continue");
            # drop the current tag being removed from the rgx...
            [regex]$rgxsvcs = ('^(' + (((Get-Variable  -name "TorMeta").value.OrgSvcs |?{$_ -ne 'AAD'} |%{[regex]::escape($_)}) -join '|') + ')$') ;
            if($host.ui.RawUI.WindowTitle -notmatch $rgxsvcs){
                write-verbose "(removing TenOrg reference from PSTitlebar)" ; 
                # in this case as we need to remove all Orgs, have to build a full list from $xxxmeta
                #Remove-PSTitlebar $TenOrg ;
                # if don't have TenOrg known, full remove:
                # split the rgx into an array of tags
                # no remove all meta tenorg tags , if no other services(??)
                $Metas=(get-variable *meta|?{$_.name -match '^\w{3}Meta$'}) ; 
                $sTitleBarTag = @($metas.name.substring(0,3)) ; 
                $sTitleBarTag += 'TMS' ; 
                Remove-PSTitlebar $sTitleBarTag ;
            } else {
                write-verbose "(detected matching OrgSvcs in PSTitlebar: *not* removing TenOrg reference)" ; 
            } ; 
        }
        catch  {
            $ErrTrpd = $Error[0] ; 
            if($TMSError.Exception.Message -eq "Object reference not set to an instance of an object."){
                Write-Host -foregroundcolor yellow "Azure AD - No active Azure Active Directory Connections" ;
            }else{
                Write-Host -foregroundcolor "MicrosoftTeams - $($ErrTrpd.Exception.Message)" ;
                $error.clear() ;
                Write-Warning "$(get-date -format 'HH:mm:ss'): Failed processing $($ErrTrpd.Exception.ItemName). `nError Message: $($ErrTrpd.Exception.Message)`nError Details: $($ErrTrpd)" ;
                $smsg = "FULL ERROR TRAPPED (EXPLICIT CATCH BLOCK WOULD LOOK LIKE): } catch[$($Error[0].Exception.GetType().FullName)]{" ; 
                if ($logging) { Write-Log -LogContent $smsg -Path $logfile -useHost -Level ERROR } #Error|Warn|Debug 
                else{ write-host -foregroundcolor green "$((get-date).ToString('HH:mm:ss')):$($smsg)" } ;
            } ; 
        
        } ;

    } else {write-host "(The MicrosoftTeams module isn't currently loaded)" } ;
} ;

#*------^ Disconnect-Teams.ps1 ^------
