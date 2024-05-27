function Set-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path,

        [Parameter(Mandatory)]
        [version]$Version,

        [Parameter(Mandatory)]
        [hashtable]$Metadata
    )

    # Get the relative path of the file from the root of the repo and trim start
    $RelativePath = Get-RelativeRootFilePath -Path $Path
    $TagName = Get-GitBlobTagName -RelativeRootPath $RelativePath -Version $Version

    # Ensure that the file has no pending changes, since we are tagging the file content together with the commit and don't want any discrepancies
    if (Test-GitFileIsModified -Path $RelativePath) {
        Write-Warning "The file '$RelativePath' has been modified. Please commit the changes before setting the version."
        return
    }

    # Set extra metadata for the tag
    if ($Metadata.ContainsKey('Commit')) { Write-Warning "The 'Commit' key was provided, and will not be overwritten with current commit." }
    $Metadata['Commit'] ??= Get-GitCurrentCommit
    
    # Assemble metadata, convert to JSON and then to Base64
    $JsonMetadata = $Metadata | ConvertTo-Json -Compress -Depth 20
    $Base64Metadata = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($JsonMetadata))

    # Tag the file with the version data as json in the tag message
    $BlobHash = Get-GitBlobHash -Path $Path
    Invoke-GitCommand 'tag', '-a', $TagName, $BlobHash, '-m', $Base64Metadata -ErrorAction Stop

    Write-Verbose "Hidden tag '$TagName' has been created for '$RelativePath'."
}