function Get-GitRepoRoot {
    [CmdletBinding()]
    param()

    Invoke-GitCommand 'rev-parse', '--show-toplevel'
}