function Invoke-GitCommand {
    [CmdletBinding()]
    param(
        [string[]]$Arguments
    )

    Write-Verbose "Invoking 'git $Arguments'."

    & git $Arguments

    if ($LASTEXITCODE -ne 0) {
        throw "Command 'git $Arguments' failed with exit code $LASTEXITCODE."
    }
}