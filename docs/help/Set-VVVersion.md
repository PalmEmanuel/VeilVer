---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Set-VVVersion

## SYNOPSIS

Sets the hidden version of a document.

## SYNTAX

```
Set-VVVersion [-Path] <String> [-Version] <Version> [-Metadata] <Hashtable>
 [<CommonParameters>]
```

## DESCRIPTION

Sets the hidden version of a document, based on git tags on the blob.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-VVVersion -DocumentPath "C:\path\to\document.md" -TagName "v1.0.0" -TagMessage "Initial release"
```

Sets the hidden version of the document at "C:\path\to\document.md" to "v1.0.0" with the message "Initial release".

## PARAMETERS

### -Metadata

The metadata to set with the document version.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path

The path to the document to set the hidden versions of.

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

### -Version

The semantic version of the document to set.

```yaml
Type: Version
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
