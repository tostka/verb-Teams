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
      [Parameter(HelpMessage="Credential to use for this connection [-credential [credential obj variable]")][System.Management.Automation.PSCredential]$Credential = $global:credo365TORSID,
      [Parameter(HelpMessage="Debugging Flag [-showDebug]")]
      [switch] $showDebug
    ) ;

    #if ($TeamsSession.state -eq 'Broken' -or !$TeamsSession) {Disconnect-Teams; Start-Sleep -Seconds 3; Connect-Teams} ;
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    #if (($TeamsSession.state -ne 'Opened' -AND $TeamsSession.Availability -ne 'Available') -or !$TeamsSession) {Disconnect-Teams; Disconnect-PssBroken ;Start-Sleep -Seconds 3; Connect-Teams} ;
      if(!$Credential){
          Connect-Teams ;
      } else {
          Connect-Teams -credential:$($Credential) -showdebug:$($showdebug) ;
      } ;
}

#*------^ Reconnect-Teams.ps1 ^------