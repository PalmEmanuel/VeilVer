# Set-VVVersion

## SYNOPSIS
Sets or updates a git tag for a document with specified metadata.

## SYNTAX

```
Set-VVVersion [-DocumentPath] <String> [-TagName] <String> [-TagMessage] <String> [[-Author] <String>] [<CommonParameters>]
```

## DESCRIPTION
The `Set-VVVersion` command is used to create or update a git tag for a document within a repository. This tag can include metadata such as the author and a message describing the change or version of the document.

## PARAMETERS

### -DocumentPath
Specifies the path to the document for which the tag is being set.

### -TagName
Specifies the name of the tag to be set or updated.

### -TagMessage
Specifies the message to be associated with the tag.

### -Author
Specifies the author of the document. This parameter is optional.

### <CommonParameters>
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

## EXAMPLES

### Example 1
```
Set-VVVersion -DocumentPath ./docs/Contoso/MyDoc1.md -TagName "contoso/MyDoc1/v1.0.2" -TagMessage "Updated MyDoc1.md" -Author "Emanuel"
```
This example sets a tag for `docs/Contoso/MyDoc1.md` with version 1.0.2 by Emanuel.

## NOTES

## RELATED LINKS
