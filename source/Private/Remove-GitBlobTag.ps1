function Remove-GitBlobTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Tag
    )

    Invoke-GitCommand 'tag', '--delete', $Tag
}