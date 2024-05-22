function Get-GitFileHistoryNames {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    # Get all names that the file has had by looking at commits that have changed the file
    # Automatically sorted by most recent (current) name first
    # Empty format string to only get the file names
    $FileNames = Invoke-GitCommand 'log', '--format=', '--name-only', '--follow', '--', $Path | Select-Object -Unique

    Write-Verbose @"
Found the following file path(s) of the file from the commit history:
- $($FileNames -join "`n- ")
"@

    Write-Output $FileNames
}