function Get-GitBlobHash {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path
    )

    $BlobHash = Invoke-GitCommand 'hash-object', '-t', 'blob', $Path

    Write-Output $BlobHash
}