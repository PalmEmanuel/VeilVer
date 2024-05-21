function Get-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path
    )

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