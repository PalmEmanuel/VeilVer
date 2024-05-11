# Git tag is case sensitive, so we need to make sure that the file name and tag creation matches always
# Should be fine if we always use the path and nothing custom

$DocSHA = git ls-tree HEAD ./docs/Contoso/MyDoc1.md --object-only
git tag contoso/mydoc1/v1.0.1 $DocSHA

# Tag file with message
git tag -a contoso/MyDoc1/v1.0.2 $(git hash-object -t blob ./docs/Contoso/MyDoc1.md) -m "author:Emanuel, message:Updated MyDoc1.md"

git show contoso/MyDoc1/v1.0.2

# Get message of tag
git tag -l --format='%(contents)' contoso/MyDoc1/v1.0.2 | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

# Get all names that the file has had by looking at commits that have changed the file
# Automatically sorted by most recent (current) name first
$FileNames = git log --format="" --name-only --follow -- ./docs/Contoso/MyDocument1.md | Select-Object -Unique

# Get all tags based on file names
foreach ($File in $FileNames) {
    $TagName = $File -replace '.md', '' -replace 'docs/',''
    git tag -l --format='%(refname:short)' --sort=-creatordate "$TagName*"
}