function Invoke-GitCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    Test-GitInstallation -ErrorAction Stop

    Write-Verbose "Invoking 'git $Arguments'."

    & git $Arguments

    if ($LASTEXITCODE -ne 0) {
        throw "Command 'git $Arguments' failed with exit code $LASTEXITCODE."
    }
}