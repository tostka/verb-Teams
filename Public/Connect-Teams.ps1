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
    # 12:10 PM 3/15/2017 disable prefix spec, unless actually blanked (e.g. centrally spec'd in profile).
    if(!$CommandPrefix){ $CommandPrefix='' ; } ;

    # shift to pulling the $MFA auto by splitting the credential and checking the o365_*_OPDomain & o365_$($credVariTag)_MFA global varis
    $MFA = get-TenantMFARequirement -Credential $Credential ;
    
    $sTitleBarTag="Teams" ;
    $TentantTag=get-TenantTag -Credential $Credential ; 
    if($TentantTag -ne 'TOR'){
        # explicitly leave this tenant (default) untagged
        $sTitleBarTag += $TentantTag ;
    } ; 
    
    $tenantID=$null ; 
    $credDom = ($Credential.username.split("@"))[1] ;
    $Metas=(gv *meta|?{$_.name -match '^\w{3}Meta$'}) ; 
    foreach ($Meta in $Metas){
        if( ($credDom -eq $Meta.value.o365_TenantDomain) -OR ($credDom -eq $Meta.value.o365_OPDomain)){
            $TentantID=$Meta.value.o365_TenantID ; 
            break ; 
        } ; 
    } ; 
       
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

    if(!(get-command -Name get-TeamHelp)){
        Try { Get-Module MicrosoftTeams -ListAvailable -ErrorAction Stop | out-null } Catch {
            if(get-module PowerShellGet){ Install-Module MicrosoftTeams -scope CurrentUser }
            else { throw "REQUIRES WIN10, PSV5+ OR installed PowerShellGet module" } ;
        } ;
        Try {Get-Module MicrosoftTeams -ErrorAction Stop | out-null } Catch {Import-Module -Name MicrosoftTeams -ErrorAction Stop  } ;
        if(!$MFA){ $Teamssplat.Add("Credential",$Credential) }
        else { $Teamssplat.Add("AccountId",$Credential.username) }
    } else { write-verbose -verbose:$true "(Teams already connected)" } ;

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
            Add-PSTitleBar $sTitleBarTag ;
            if(($PSFgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSFgColor) -AND ($PSBgColor = (Get-Variable  -name "$($TenOrg)Meta").value.PSBgColor)){
                $Host.UI.RawUI.BackgroundColor = $PSBgColor
                $Host.UI.RawUI.ForegroundColor = $PSFgColor ; 
            } ;
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