function Get-GitCurrentCommit {
    [CmdletBinding()]
    param ()

    Invoke-GitCommand 'rev-parse', '--verify', 'HEAD'
}