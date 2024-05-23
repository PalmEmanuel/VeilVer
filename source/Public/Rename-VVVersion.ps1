function Rename-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FilePath
    )

    # Ensure the file exists
    if (-not (Test-Path -Path $FilePath)) {
        Write-Error "File path '$FilePath' does not exist."
        return
    }

    # Retrieve all historical names of the file
    $HistoricalNames = Get-GitFileHistoryNames -Path $FilePath

    # Find all tags associated with the file's historical names
    $Tags = $HistoricalNames | ForEach-Object {
        Get-GitBlobTags -RelativeRootPath $_
    }

    # Remove old tags and recreate them with the new file path
    foreach ($Tag in $Tags) {
        if ($Tag.File -ne $FilePath) {
            Remove-VVVersion -Tag $Tag.Tag
            Set-VVVersion -Path $FilePath -Version $Tag.Version -Metadata $Tag.Metadata
        }
    }

    Write-Verbose "All git tags for '$FilePath' have been updated to its current file name."
}
