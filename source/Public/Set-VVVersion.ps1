function Set-VVVersion {
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