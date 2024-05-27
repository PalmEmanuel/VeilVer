function Test-GitBlobTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Tag
    )
    
    try {
        $null = Invoke-GitCommand 'tag', '--list', $Tag
    } catch {}

    # Returns true if the tag exists
    $LASTEXITCODE -eq 0
}