# import-MGTeamsModule.ps1

#*------v import-MGTeamsModule.ps1 v------
function import-MGTeamsModule {
    <#
    .SYNOPSIS
    import-MGTeamsModule - Import the Microsoft.Graph.Teams sub module of the monster Microsoft.Graph module
    .NOTES
    Version     : 1.0.0.
    Author      : Todd Kadrie
    Website     : http://www.toddomation.com
    Twitter     : @tostka / http://twitter.com/tostka
    CreatedDate : 2025-02-20
    FileName    : import-MGTeamsModule
    License     : MIT License
    Copyright   : (c) 2025 Todd Kadrie
    Github      : https://github.com/tostka
    Tags        : Powershell,ISE,development,debugging,Teams,MicrosoftGraphModule,MicrosoftGraphTeams
    REVISIONS
    * 11:31 AM 2/20/2025 init
    .DESCRIPTION
    import-MGTeamsModule - Import the Microsoft.Graph.Teams sub module of the monster Microsoft.Graph module
    (Microsoft.Graph is too larget to ipmo - throws capacity errors)
    .EXAMPLE
    import-MGTeamsModule ; 
    .LINK
    Github      : https://github.com/tostka/verb-Teams
    #>
    [CmdletBinding()]
    [Alias('ipmoMgTms','ipmoMGTeams')]
    #[ValidateScript({Test-Path $_})]
    PARAM(
    ) ;
    BEGIN {
        $tsubmod = 'Microsoft.Graph.Teams' ; 
    } ;
    PROCESS {
        Import-Module $tsubmod -Force -Verbose:$($PSBoundParameters['Verbose'] -eq $true)
    } # PROC-E
}
#*------^ import-MGTeamsModule.ps1 ^------


