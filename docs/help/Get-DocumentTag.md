# Get-VVVersion

## SYNOPSIS
Retrieves git tags and their associated messages for a document.

## SYNTAX

```
Get-VVVersion [-DocumentPath] <String> [<CommonParameters>]
```

## DESCRIPTION
The `Get-VVVersion` command retrieves all git tags associated with a document, along with their messages. It is useful for tracking document versions and metadata.

## PARAMETERS

### -DocumentPath
Specifies the path to the document for which to retrieve tags.

## EXAMPLES

### Example 1
```
PS C:\> Get-VVVersion -DocumentPath ./docs/Contoso/MyDoc1.md
```
This command gets all tags for the document `MyDoc1.md` in the `Contoso` directory.

## RELATED LINKS
[Set-VVVersion](Set-VVVersion.md)
