$DocSHA = git ls-tree HEAD ./docs/Contoso/MyDoc1.md --object-only
git tag contoso/mydoc1/v1.0.1 $DocSHA

git tag contoso/MyDoc1/v1.0.1 $(git hash-object -t blob -w ./docs/Contoso/MyDoc1.md)

git tag -a contoso/MyDoc1/v1.0.1 $(git hash-object -t blob -w ./docs/Contoso/MyDoc1.md) -m "author:Emanuel"

git show contoso/MyDoc1/v1.0.1