function Get-DocumentTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$DocumentPath
    )

    # Ensure git is available
    if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not available. Please install Git to use this command."
        return
    }

    # Get all names that the file has had by looking at commits that have changed the file
    # Automatically sorted by most recent (current) name first
    $FileNames = git log --format="" --name-only --follow -- $DocumentPath | Select-Object -Unique

    # Get all tags based on file names
    foreach ($File in $FileNames) {
        $TagName = $File -replace '.md', '' -replace 'docs/',''
        $Tags = git tag -l --format='%(refname:short)' --sort=-creatordate "$TagName*"
        foreach ($Tag in $Tags) {
            $TagMessage = git tag -l --format='%(contents)' $Tag | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
            Write-Host "$Tag: $TagMessage"
        }
    }
}

function Set-DocumentTag {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$DocumentPath,

        [Parameter(Mandatory=$true)]
        [string]$TagName,

        [Parameter(Mandatory=$true)]
        [string]$TagMessage,

        [Parameter(Mandatory=$false)]
        [string]$Author = "Unknown"
    )

    # Ensure git is available
    if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not available. Please install Git to use this command."
        return
    }

    # Create or update git tag for document
    $DocSHA = git ls-tree HEAD $DocumentPath --object-only
    if (-not $DocSHA) {
        Write-Error "Document not found in the current git repository."
        return
    }

    # Tag file with message
    git tag -a $TagName $(git hash-object -t blob $DocumentPath) -m "author:$Author, message:$TagMessage"

    Write-Host "Tag '$TagName' has been created or updated for document '$DocumentPath'."
}
