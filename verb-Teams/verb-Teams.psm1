﻿# verb-teams.psm1


<#
.SYNOPSIS
verb-Teams - Powershell Teams generic functions module
.NOTES
Version     : 1.0.18.0
Author      : Todd Kadrie
Website     :	https://www.toddomation.com
Twitter     :	@tostka
CreatedDate : 5/12/2020
FileName    : verb-Teams.psm1
License     : MIT
Copyright   : (c) 5/12/2020 Todd Kadrie
Github      : https://github.com/tostka
AddedCredit : REFERENCE
AddedWebsite:	REFERENCEURL
AddedTwitter:	@HANDLE / http://twitter.com/HANDLE
REVISIONS
* 5/12/2020 - 1.0.0.0
* 9:37 AM 5/12/2020 genericized for module port
# 11:38 AM 12/30/2019 ran vsc alias-expan
* 10:55 AM 12/6/2019 Connect-Teams:added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
* 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
* 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
# 8:23 PM 11/20/2019 refacored for updated MFA
* 11:04 AM 6/17/2019 fixed typos, remmed TenentID matrl, really strippedback
* 8:39 AM 6/17/2019 init version
.DESCRIPTION
verb-Teams - Powershell Teams generic functions module
.EXAMPLE
.EXAMPLE
.LINK
https://github.com/tostka/verb-Teams
#>


    $script:ModuleRoot = $PSScriptRoot ;
    $script:ModuleVersion = (Import-PowerShellDataFile -Path (get-childitem $script:moduleroot\*.psd1).fullname).moduleversion ;
    $runningInVsCode = $env:TERM_PROGRAM -eq 'vscode' ;

#*======v FUNCTIONS v======




#*------v Connect-Teams.ps1 v------
Function Connect-Teams {
    <#
    .SYNOPSIS
    Connect-Teams - Establish PSS to https://ps.compliance.protection.outlook.com/powershell-liveid/
    .NOTES
    Author: Todd Kadrie
    Website:	http://toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    AddedCredit : Inspired by concept code by ExactMike Perficient, Global Knowl... (Partner)
    AddedWebsite:	https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    Version     : 1.1.0
    CreatedDate : 2020-02-24
    FileName    : Connect-Ex2010()
    License     : MIT License
    Copyright   : (c) 2020 Todd Kadrie
    Github      : https://github.com/tostka
    Tags        : Powershell,Teams
    REVISIONS   :
    * 1:30 PM 9/5/2024 added  update-SecurityProtocolTDO() SB to begin
    * 4:41 PM 7/27/2021 updates around pstitlebar & retire of sep SOL module - looks like the get-csTenant cmd would be good status check, but I'm getting errors on all -cs commands
    get-cstenant
Exception calling "GetSteppablePipeline" with "1" argument(s): "Cannot process argument because the value of argument "commandInfo" is null. Change the value 
of argument "commandInfo" to a non-null value."
At $($env:userprofile)\Documents\WindowsPowerShell\Modules\MicrosoftTeams\2.3.1\net472\SfBORemotePowershellModule.psm1:15273 char:13
+             $steppablePipeline = $scriptCmd.GetSteppablePipeline($myI ...
+             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : CmdletInvocationException
    * 10:40 AM 4/8/2021 added -ea 0 to the gcm cmd testing for existing conn
    * 2:44 PM 3/2/2021 added console TenOrg color support
    * 7:13 AM 7/22/2020 replaced codeblock w get-TenantTag()
    * 5:20 PM 7/21/2020 added ven supp
    * 12:32 PM 5/27/2020 updated cbh, added alias cTms win func
    * 10:55 AM 12/6/2019 Connect-Teams:added suffix to TitleBar tag for non-TOR tenants, also config'd a central tab vari
    * 5:14 PM 11/27/2019 repl $MFA code with get-TenantMFARequirement
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 8:29 PM 11/20/2019 updated for MFA
    # 1:31 PM 7/9/2018 added suffix hint: if($CommandPrefix){ '(Connected to Teams: Cmds prefixed [verb]-cc[Noun])' ; } ;
    # 12:25 PM 6/20/2018 port from cxo:     Primary diff from EXO connect is the "-ConnectionUri https://ps.compliance.protection.outlook.com/powershell-liveid/" all else is the same, repurpose connect-EXO to this
    .DESCRIPTION

    ```powershell
    Connect to MicrosoftTeams using Accesstokens
    This example demonstrates how to sign in using AccessTokens. Admin can reterive Access Tokens. It requires two tokens, MS Graph Access Token and Teams Resource token.
    PowerShell
    $graphtoken = #Get MSGraph Token for following for resource  "https://graph.microsoft.com" and scopes "AppCatalog.ReadWrite.All", "Group.ReadWrite.All", "User.Read.All";
    $teamstoken = #Get Teams resource token for resource id "48ac35b8-9aa8-4d74-927d-1f4a14a0b239" and scope "user_impersonation";
    Connect-MicrosoftTeams -AccessTokens @($graphtoken, $teamstoken) -AccountId $adminaccount
    Account                 Environment 	Tenant                                TenantId
    -------                 -----------  ------------------------------------  ------------------------------------
    user@contoso.com        AzureCloud   xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    ```
    .PARAMETER  ProxyEnabled
    Use Proxy-Aware SessionOption settings [-ProxyEnabled]
    .PARAMETER  CommandPrefix
    [noun]-PREFIX[command] PREFIX string for clearly marking cmdlets sourced in this connection [-CommandPrefix exolab ]
    .PARAMETER  Credential
    Credential to use for this connection [-credential 'logon@DOMAIN.com']
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Connect-Teams
    Connect using defaults, and leverage any pre-set $global:o365cred variable
    .EXAMPLE
    Connect-Teams -CommandPrefix exo -credential (Get-Credential -credential logon@DOMAIN.com)  ;
    Connect an explicit credential, and use 'exolab' as the cmdlet prefix
    .LINK
    https://docs.microsoft.com/en-us/powershell/exchange/office-365-scc/connect-to-scc-powershell/connect-to-scc-powershell?view=exchange-ps
    *---^ END Comment-based Help  ^--- #>

<#
SYNTAX
    Connect-MicrosoftTeams [-AadAccessToken <String>] [-AccountId <String>] [-Confirm] [-LogFilePath <String>] [-LogLevel <LogLevel>] [-MsAccessToken <String>] [-TenantId <String>] [-WhatIf]
    [<CommonParameters>]
    Connect-MicrosoftTeams [-AccountId <String>] [-Confirm] [-Credential <PSCredential>] [-LogFilePath <String>] [-LogLevel <LogLevel>] [-TenantId <String>] [-WhatIf] [<CommonParameters>]
    Connect-MicrosoftTeams -ApplicationId <String> -CertificateThumbprint <String> [-Confirm] [-LogFilePath <String>] [-LogLevel <LogLevel>] -TenantId <String> [-WhatIf] [<CommonParameters>]
DESCRIPTION
PARAMETERS
    -AadAccessToken <String>
        Specifies a Azure Active Directory Graph access token.
    -AccountId <String>
        Specifies the ID of an account. You must specify the UPN of the user when authenticating with a user access token.
    -ApplicationId <String>
        Specifies the application ID of the service principal.
    -CertificateThumbprint <String>
        Specifies the certificate thumbprint of a digital public key X.509 certificate of a user account that has permission to perform this action.
    -Confirm [<SwitchParameter>]
        Prompts you for confirmation before running the cmdlet.
    -Credential <PSCredential>
        Specifies a PSCredential object. For more information about the PSCredential object, type Get-Help Get-Credential.
        The PSCredential object provides the user ID and password for organizational ID credentials.
    -LogFilePath <String>
        The path where the log file for this PowerShell session is written to. Provide a value here if you need to deviate from the default PowerShell log file location.
    -LogLevel <LogLevel>
        Specifies the log level.  The acceptable values for this parameter are:
        - Info
        - Error
        - Warning
        - None
        The default value is Info.
    -MsAccessToken <String>
        Specifies a Microsoft Graph access token.
    -TenantId <String>
        Specifies the ID of a tenant.
        If you do not specify this parameter, the account is authenticated with the home tenant.
        You must specify the TenantId parameter to authenticate as a service principal or when using Microsoft account.
    -WhatIf [<SwitchParameter>]
        Shows what would happen if the cmdlet runs. The cmdlet is not run.
#>
    [CmdletBinding()]
    [Alias('cTms')]
   Param(
        [Parameter(HelpMessage="Credential to use for this connection [-credential 'logon@DOMAIN.com']")]
        $Credential = $global:credo365TORSID,
        [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
        [switch] $showDebug
    ) ;
	$Verbose = ($VerbosePreference -eq 'Continue')        
	$CurrentVersionTlsLabel = [Net.ServicePointManager]::SecurityProtocol ; # Tls, Tls11, Tls12 ('Tls' == TLS1.0)  ;
	write-verbose "PRE: `$CurrentVersionTlsLabel : $($CurrentVersionTlsLabel )" ; 
	# psv6+ already covers, test via the SslProtocol parameter presense
	if ('SslProtocol' -notin (Get-Command Invoke-RestMethod).Parameters.Keys) {
		$currentMaxTlsValue = [Math]::Max([Net.ServicePointManager]::SecurityProtocol.value__,[Net.SecurityProtocolType]::Tls.value__) ; 
		write-verbose "`$currentMaxTlsValue : $($currentMaxTlsValue )" ; 
		$newerTlsTypeEnums = [enum]::GetValues('Net.SecurityProtocolType') | Where-Object { $_ -gt $currentMaxTlsValue }
		if($newerTlsTypeEnums){
			write-verbose "Appending upgraded/missing TLS `$enums:`n$(($newerTlsTypeEnums -join ','|out-string).trim())" ; 
		} else {
			write-verbose "Current TLS `$enums are up to date with max rev available on this machine" ; 
		}; 
		$newerTlsTypeEnums | ForEach-Object {
			[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $_
		} ; 
	} ;		
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ $CommandPrefix='' ; } ;

    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ;
    
    $sTitleBarTag=@("TMS") ;
    $TentantTag= $TenOrg =get-TenantTag -Credential $Credential ; 
    $sTitleBarTag += $TentantTag ;
    
    $tenantID=$null ; 
    $credDom = ($Credential.username.split("@"))[1] ;
    <#
    $Metas=(gv *meta|?{$_.name -match '^\w{3}Meta$'}) ; 
    foreach ($Meta in $Metas){
        if( ($credDom -eq $Meta.value.o365_TenantDomain) -OR ($credDom -eq $Meta.value.o365_OPDomain)){
            $TentantID=$Meta.value.o365_TenantID ; 
            break ; 
        } ; 
    } ; 
    #> 
    # flip to dedicated function 
    $TenantID = get-TenantID -Credential $Credential ;

     <# non-MFA code - appears to be redundant to below
    if(!(get-command -Name get-TeamHelp)){
        Try { Get-Module MicrosoftTeams -ListAvailable -ErrorAction Stop | out-null } Catch {
            if(get-module PowerShellGet){ Install-Module MicrosoftTeams -scope CurrentUser }
            else { throw "REQUIRES WIN10, PSV5+ OR installed PowerShellGet module" } ;
        } ;
        Try {Get-Module MicrosoftTeams -ErrorAction Stop | out-null } Catch {Import-Module -Name MicrosoftTeams -ErrorAction Stop  } ;
        Connect-MicrosoftTeams -TenantID $tenantID -cred $cred ;
    } else { write-verbose -verbose:$true "(Teams already connected)" } ;
    #>


    # 9:17 AM 3/15/2017 Connect-Teams: add quotes around all string/non-boolean/non-int values in the splat
    # TenantID=$TenantID ;

    $Teamssplat=@{        
    } ;
    if($TenantID){ $Teamssplat.Add("TenantID",$tenantID) }

    if(!(get-command -Name get-TeamHelp -ea 0)){
        Try { Get-Module MicrosoftTeams -ListAvailable -ErrorAction Stop | out-null } Catch {
            if(get-module PowerShellGet){ Install-Module MicrosoftTeams -scope CurrentUser }
            else { throw "REQUIRES WIN10, PSV5+ OR installed PowerShellGet module" } ;
        } ;
        Try {Get-Module MicrosoftTeams -ErrorAction Stop | out-null } Catch {Import-Module -Name MicrosoftTeams -ErrorAction Stop  } ;
        if(!$MFA){ $Teamssplat.Add("Credential",$Credential) }
        else { $Teamssplat.Add("AccountId",$Credential.username) }
        write-verbose "(using cred:$($credential.username))" ; 
    } else { write-host -foregroundcolor yellow "(Teams already connected)" } ;

    Write-Host "Connect-MicrosoftTeams..."  ;
    $Exit = 0 ; # zero out $exit each new cmd try/retried
    # do loop until up to 4 retries...
    Do {
        $error.clear() ;# 11:42 AM 9/11/2017 add preclear, we're going to post-test the $error
        Try {
            # can't seem to capture output of it
            Connect-MicrosoftTeams @Teamssplat ;
            if($error.count -ne 0) {
                # azure error, not teams specific test
                if($error[0].FullyQualifiedErrorId -eq '-2144108477,PSSessionOpenFailed'){
                    write-warning "$((get-date).ToString('HH:mm:ss')):AUTH FAIL BAD PASSWORD? ABORTING TO AVOID LOCKOUT!" ;
                    throw "$((get-date).ToString('HH:mm:ss')):AUTH FAIL BAD PASSWORD? ABORTING TO AVOID LOCKOUT!" ;
                    EXIT ;
                } ;
            } ;
            # I want to see where I connected...
            Add-PSTitleBar $sTitleBarTag -verbose:$($VerbosePreference -eq "Continue")  ;
            <# borked by psreadline v1/v2 breaking changes
            if(($PSFgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSFgColor) -AND ($PSBgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSBgColor)){
                write-verbose "(setting console colors:$($TenOrg)Meta.PSFgColor:$($PSFgColor),PSBgColor:$($PSBgColor))" ; 
                $Host.UI.RawUI.BackgroundColor = $PSBgColor
                $Host.UI.RawUI.ForegroundColor = $PSFgColor ; 
            } ;
            #>
            $Exit = $Retries ;
        } Catch {
            # capture auth errors - nope, they never get here, if use throw, it doesn't pass in the auth $error, gens a new one.
            # pause to give it time to reset
            Start-Sleep -Seconds $RetrySleep ;
            $Exit ++ ;
            Write-Verbose "Failed to exec cmd because: $($Error[0])" ;
            Write-Verbose "Try #: $Exit" ;
            If ($Exit -eq $Retries) {Write-Warning "Unable to exec cmd!"} ;
        } # try-E
    } Until ($Exit -eq $Retries) # loop-E
}

#*------^ Connect-Teams.ps1 ^------


#*------v cTmscmw.ps1 v------
function cTmscmw {Connect-Teams -cred $credO365CMWCSID}

#*------^ cTmscmw.ps1 ^------


#*------v cTmstol.ps1 v------
function cTmstol {Connect-Teams -cred $credO365TOLSID}

#*------^ cTmstol.ps1 ^------


#*------v cTmstor.ps1 v------
function cTmstor {Connect-Teams -cred $credO365TORSID}

#*------^ cTmstor.ps1 ^------


#*------v cTmsVEN.ps1 v------
function cTmsVEN {Connect-Teams -cred $credO365VENCSID}

#*------^ cTmsVEN.ps1 ^------


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
}

#*------^ Disconnect-Teams.ps1 ^------


#*------v Reconnect-Teams.ps1 v------
Function Reconnect-Teams {
    <#
    .SYNOPSIS
    Reconnect-Teams - Test and reestablish PSS to https://ps.outlook.com/powershell/
    .NOTES
    Author: Todd Kadrie
    Website:	http://toddomation.com
    Twitter     :	@tostka / http://twitter.com/tostka
    AddedCredit : Inspired by concept code by ExactMike Perficient, Global Knowl... (Partner)
    AddedWebsite:	https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    Version     : 1.1.0
    CreatedDate : 2020-02-24
    FileName    : Connect-Ex2010()
    License     : MIT License
    Copyright   : (c) 2020 Todd Kadrie
    Github      : https://github.com/tostka
    Tags        : Powershell
    REVISIONS   :
    * 2:44 PM 7/27/2021 added verbose call support
    * 12:34 PM 5/27/2020 updated cbh, added alias:rtms
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 8:28 PM 11/20/2019 updated for cred & mfa
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 Teams variant, works
    .DESCRIPTION
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    I use this for routine test/reconnect of Teams.
    .PARAMETER  Credential
    Credential to use for this connection [-credential 'logon@domain.com']
    .INPUTS
    None. Does not accepted piped input.
    .OUTPUTS
    None. Returns no objects or output.
    .EXAMPLE
    Reconnect-Teams;
    .LINK
    https://social.technet.microsoft.com/Forums/msonline/en-US/f3292898-9b8c-482a-86f0-3caccc0bd3e5/exchange-powershell-monitoring-remote-sessions?forum=onlineservicesexchange
    #>
    [CmdletBinding()]
    [Alias('rTms')]
    Param(
      [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")]
      [System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
      [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
      [switch] $showDebug
    ) ;
    $verbose = $($VerbosePreference -eq "Continue") ; 
    #if ($TeamsSession.state -eq 'Broken' -or !$TeamsSession) {Disconnect-Teams; Start-Sleep -Seconds 3; Connect-Teams} ;
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($TeamsSession.state -ne 'Opened' -AND $TeamsSession.Availability -ne 'Available') -or !$TeamsSession) {Disconnect-Teams; Disconnect-PssBroken ;Start-Sleep -Seconds 3; Connect-Teams} ;
      if(!$Credential){
          Connect-Teams ;
      } else {
          Connect-Teams -credential:$($Credential) -showdebug:$($showdebug) -verbose:$($VerbosePreference -eq "Continue") ;
      } ;
}

#*------^ Reconnect-Teams.ps1 ^------


#*------v rTmscmw.ps1 v------
function rTmscmw {Reconnect-Teams -cred $credO365CMWCSID}

#*------^ rTmscmw.ps1 ^------


#*------v rTmstol.ps1 v------
function rTmstol {Reconnect-Teams -cred $credO365TOLSID}

#*------^ rTmstol.ps1 ^------


#*------v rTmstor.ps1 v------
function rTmstor {Reconnect-Teams -cred $credO365TORSID}

#*------^ rTmstor.ps1 ^------


#*------v rTmsVEN.ps1 v------
function rTmsVEN {Reconnect-Teams -cred $credO365VENCSID}

#*------^ rTmsVEN.ps1 ^------


#*======^ END FUNCTIONS ^======

Export-ModuleMember -Function Connect-Teams,cTmscmw,cTmstol,cTmstor,cTmsVEN,Disconnect-Teams,Reconnect-Teams,rTmscmw,rTmstol,rTmstor,rTmsVEN -Alias *




# SIG # Begin signature block
# MIIELgYJKoZIhvcNAQcCoIIEHzCCBBsCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUIthsU7cQH4WtLIHFQ7txBge6
# vC6gggI4MIICNDCCAaGgAwIBAgIQWsnStFUuSIVNR8uhNSlE6TAJBgUrDgMCHQUA
# MCwxKjAoBgNVBAMTIVBvd2VyU2hlbGwgTG9jYWwgQ2VydGlmaWNhdGUgUm9vdDAe
# Fw0xNDEyMjkxNzA3MzNaFw0zOTEyMzEyMzU5NTlaMBUxEzARBgNVBAMTClRvZGRT
# ZWxmSUkwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALqRVt7uNweTkZZ+16QG
# a+NnFYNRPPa8Bnm071ohGe27jNWKPVUbDfd0OY2sqCBQCEFVb5pqcIECRRnlhN5H
# +EEJmm2x9AU0uS7IHxHeUo8fkW4vm49adkat5gAoOZOwbuNntBOAJy9LCyNs4F1I
# KKphP3TyDwe8XqsEVwB2m9FPAgMBAAGjdjB0MBMGA1UdJQQMMAoGCCsGAQUFBwMD
# MF0GA1UdAQRWMFSAEL95r+Rh65kgqZl+tgchMuKhLjAsMSowKAYDVQQDEyFQb3dl
# clNoZWxsIExvY2FsIENlcnRpZmljYXRlIFJvb3SCEGwiXbeZNci7Rxiz/r43gVsw
# CQYFKw4DAh0FAAOBgQB6ECSnXHUs7/bCr6Z556K6IDJNWsccjcV89fHA/zKMX0w0
# 6NefCtxas/QHUA9mS87HRHLzKjFqweA3BnQ5lr5mPDlho8U90Nvtpj58G9I5SPUg
# CspNr5jEHOL5EdJFBIv3zI2jQ8TPbFGC0Cz72+4oYzSxWpftNX41MmEsZkMaADGC
# AWAwggFcAgEBMEAwLDEqMCgGA1UEAxMhUG93ZXJTaGVsbCBMb2NhbCBDZXJ0aWZp
# Y2F0ZSBSb290AhBaydK0VS5IhU1Hy6E1KUTpMAkGBSsOAwIaBQCgeDAYBgorBgEE
# AYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEEMBwG
# CisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBSuXA1+
# aWE/TjoMCC8nssXOHaLlpzANBgkqhkiG9w0BAQEFAASBgASBNmbxWLmooUc6UFXW
# xqsdpUJ5n6Aos1bTaq8L4gKBcVCB88h+iWgbyeW18vgzk8p+rzSFUQjyIKwkp3gc
# UPqeTXw9Qgr/5g8fcASdqTWvgfyJkQwevf1JyeR6GMnwXDi88EBBZTo9ounSz6wl
# 94mI7kRtCEJhaEEBn88UN9xU
# SIG # End signature block
