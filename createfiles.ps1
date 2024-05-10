$DocSHA = git ls-tree HEAD ./docs/Contoso/MyDoc1.md --object-only
git tag contoso/mydoc1/v1.0.1 $DocSHA

git tag -a contoso/MyDoc1/v1.0.2 $(git hash-object -t blob ./docs/Contoso/MyDoc1.md) -m "author:Emanuel, message:Updated MyDoc1.md"

git show contoso/MyDoc1/v1.0.2

git tag -l --format='%(contents)' contoso/MyDoc1/v1.0.2 | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }