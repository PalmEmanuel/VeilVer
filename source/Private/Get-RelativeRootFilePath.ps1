function Get-RelativeRootFilePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$Path
    )

    Push-Location (Get-GitRepoRoot)

    # Trim slashes from relative path
    $RelativePath = (Resolve-Path $Path -Relative).TrimStart('.\').TrimStart('./')

    Pop-Location

    Write-Output $RelativePath
}