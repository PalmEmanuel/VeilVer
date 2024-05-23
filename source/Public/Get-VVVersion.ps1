function Get-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path,

        [Parameter(Mandatory, ParameterSetName = 'Checkout', HelpMessage = 'Checkout the version as a file using git blob tags.')]
        [switch]$Checkout,

        [Parameter(Mandatory, ParameterSetName = 'Checkout')]
        [version]$Version
    )

    if ($Checkout) {
        # Ensure the path and version are specified for checkout
        if (-not $Path -or -not $Version) {
            Write-Error "Both -Path and -Version parameters must be specified when using -Checkout."
            return
        }

        # Checkout logic
        $RelativePath = (Resolve-Path $Path -Relative).TrimStart('.\').TrimStart('./')
        $TagName = "VV/$RelativePath/v$Version"
        $TagExists = Invoke-GitCommand 'tag', '--list', $TagName

        if (-not $TagExists) {
            Write-Error "The specified version tag '$TagName' does not exist."
            return
        }

        $BlobHash = Invoke-GitCommand 'rev-parse', $TagName
        Invoke-GitCommand 'checkout', $BlobHash, '--', $Path
        Write-Verbose "Checked out version '$Version' of '$Path' successfully."
        return
    }

    # Get all tags based on file names
    $FileNames = Get-GitFileHistoryNames -Path $Path
    Write-Verbose @"
Found the following file path(s) of the file through the commit history:
- $($FileNames -join "`n- ")
"@
    $Tags = $FileNames | ForEach-Object {
        Get-GitBlobTags -RelativeRootPath $_
    }

    if ($Tags.Count -eq 0) {
        Write-Warning "No hidden version tags found for the file '$Path'."
        return
    }

    Write-Output $Tags
}
