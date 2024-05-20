function Get-VVVersion {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    Test-GitInstallation

    # Get all names that the file has had by looking at commits that have changed the file
    # Automatically sorted by most recent (current) name first
    $FileNames = git log --format="" --name-only --follow -- $Path | Select-Object -Unique

    # Get all tags based on file names
    foreach ($File in $FileNames) {
        $TagName = $File -replace '.md', '' -replace 'docs/',''
        $Tags = git tag -l --format='%(refname:short)' --sort=-creatordate "$TagName*"
        foreach ($Tag in $Tags) {
            $TagMessage = git tag -l --format='%(contents)' $Tag | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            Write-Host "$Tag : $TagMessage"
        }
    }
}