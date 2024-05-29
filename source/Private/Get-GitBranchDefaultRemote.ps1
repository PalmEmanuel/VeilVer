function Get-GitBranchDefaultRemote {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Branch = (Invoke-GitCommand 'branch' '--show-current')
    )

    # Get the default remote of the branch
    $DefaultRemote = Invoke-GitCommand 'branch', '--list', $Branch, '--format=%(upstream:remotename)'
    if ([string]::IsNullOrWhiteSpace($DefaultRemote)) {
        throw "Could not get a remote set for the branch '$Branch'."
    }

    Write-Output $DefaultRemote
}