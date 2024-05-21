function Get-GitFileHistoryNames {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    # Get all names that the file has had by looking at commits that have changed the file
    # Automatically sorted by most recent (current) name first
    # Empty format string to only get the file names
    Invoke-GitCommand 'log', '--format=', '--name-only', '--follow', '--', $Path | Select-Object -Unique
}