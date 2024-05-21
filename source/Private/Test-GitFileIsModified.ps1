function Test-GitFileIsModified {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path
    )

    try {
        $null = Invoke-GitCommand 'diff-index', 'HEAD', '--quiet', '--', $Path
    } catch {}
    
    # Returns true if the file has been modified
    $LASTEXITCODE -eq 1
}