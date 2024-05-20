---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Get-VVVersion

## SYNOPSIS

Gets the hidden version of a document.

## SYNTAX

```
Get-VVVersion [-DocumentPath] <String> [<CommonParameters>]
```

## DESCRIPTION

Gets the hidden version of a document, based on git tags on the blob.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-VVVersion -DocumentPath "C:\path\to\document.md"
```

Gets the hidden version of the document at "C:\path\to\document.md".

## PARAMETERS

### -DocumentPath

Specifies the path to the document.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
