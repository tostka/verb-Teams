#*------v Reconnect-Teams.ps1 v------
Function Reconnect-Teams {
    <#
    .SYNOPSIS
    Reconnect-Teams - Test and reestablish PSS to https://ps.outlook.com/powershell/
    .NOTES
    Author: Todd Kadrie
    Website:	https://www.toddomation.com
    Twitter:	https://twitter.com/tostka
    Port of my verb-EXO functs for o365 Sec & Compliance Ctr RemPS
    REVISIONS   :
    * 1:07 PM 11/25/2019 added *tol/*tor/*cmw alias variants for connect & reconnect
    # 8:28 PM 11/20/2019 updated for cred & mfa
    # 1:24 PM 11/7/2018 switch the test to $EOLSession.state -ne 'Opened' -AND $EOLSession.Availability -ne 'Available'
    # 1:04 PM 6/20/2018 Teams variant, works
    .DESCRIPTION
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