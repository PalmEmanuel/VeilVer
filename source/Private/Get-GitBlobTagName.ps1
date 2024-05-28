function Get-GitBlobTagName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [Parameter(Mandatory, ParameterSetName = 'Pattern')]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$RelativeRootPath,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [version]$Version,
        
        [Parameter(Mandatory, ParameterSetName = 'Pattern')]
        [switch]$Pattern
    )

    if ($Pattern) {
        $OutputString = "@VV/$RelativeRootPath/v*"
    } else {
        $OutputString = "@VV/$RelativeRootPath/v$Version"
    }

    Write-Output $OutputString
}