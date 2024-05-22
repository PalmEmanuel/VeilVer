function Remove-GitBlobTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Tag
    )

    $null = Invoke-GitCommand 'tag', '--delete', $Tag
}
