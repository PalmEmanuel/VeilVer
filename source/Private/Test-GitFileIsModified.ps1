function Test-GitFileIsModified {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$Path
    )

    try {
        $null = Invoke-GitCommand 'diff-index', 'HEAD', '--quiet', '--', $Path
    } catch {}
    
    # Returns true if the file has been modified
    $LASTEXITCODE -eq 1
}