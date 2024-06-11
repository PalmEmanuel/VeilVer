function Rename-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path
    )

    # Get the relative path of the file from the root of the repo and trim start
    $RelativePath = Get-RelativeRootFilePath -Path $Path

    # Ensure that the file has no pending changes, since we are tagging the file content together with the commit and don't want any discrepancies
    if (Test-GitFileIsModified -Path $RelativePath) {
        Write-Warning "The file '$RelativePath' has been modified. Please commit the changes before setting the version."
        return
    }

    # Ensure the file exists
    if (-not (Test-Path -Path $Path)) {
        Write-Error "File path '$Path' does not exist."
        return
    }

    # Retrieve all historical names of the file
    $HistoricalNames = Get-GitFileHistoryNames -Path $Path

    # Find all tags associated with the file's historical names
    $Tags = $HistoricalNames | ForEach-Object {
        Get-GitBlobTags -RelativeRootPath $_
    }

    # Remove old tags and recreate them with the new file path
    foreach ($Tag in $Tags) {
        if ($Tag.File -ne $Path) {
            Remove-VVVersion -Tag $Tag.Tag
            Set-VVVersion -Path $Path -Version $Tag.Version -Metadata $Tag.Metadata
        }
    }

    Write-Verbose "All git tags for '$Path' have been updated to its current file name."
}
