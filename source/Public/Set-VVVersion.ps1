function Set-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path,

        [Parameter(Mandatory)]
        [version]$Version,

        [Parameter(Mandatory)]
        [hashtable]$VersionData
    )

    try {

        Test-GitInstallation
    
        # Get root of repo
        $GitArguments = "rev-parse", "--show-toplevel"
        $RepoRoot = Invoke-GitCommand $GitArguments
        Push-Location $RepoRoot

        # Get the relative path of the file from the root of the repo
        $TagName = "VV/$((Resolve-Path $Path -Relative).TrimStart('.\').TrimStart('./'))/v$Version"
        Write-Verbose "Tag name: $TagName"
    
        # Tag the file with the version data as json in the tag message
        $GitArguments = "tag", "-a", $TagName, $(git hash-object -t blob $Path), "-m", "'$($VersionData | ConvertTo-Json -Compress)'"
        Invoke-GitCommand $GitArguments

        Write-Verbose "Tag '$TagName' has been created or updated for document '$Path'."
    } finally {
        Pop-Location
    }
}