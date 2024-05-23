---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Get-VVVersion

## SYNOPSIS

Gets the hidden version of a document or checks out a version as a file using git blob tags.

## SYNTAX

### Default (Default)
```
Get-VVVersion [-Path] <String> [<CommonParameters>]
```

### Checkout
```
Get-VVVersion [-Path] <String> [-Checkout] [-Version] <Version> [<CommonParameters>]
```

## DESCRIPTION

Gets the hidden version of a document, based on git tags on the blob. If the `-Checkout` parameter is specified, it checks out the version as a file using git blob tags.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-VVVersion -Path "C:\path\to\document.md"
```

Gets the hidden version of the document at "C:\path\to\document.md".

### Example 2
```powershell
PS C:\> Get-VVVersion -Path "C:\path\to\document.md" -Checkout -Version 1.2.3
```

Checks out version 1.2.3 of the document at "C:\path\to\document.md" as a file using git blob tags.

## PARAMETERS

### -Path

The path to the document to get the hidden versions of or to checkout a version from.

```yaml
Type: String
Parameter Sets: Default, Checkout
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Checkout

Indicates that the command should checkout the version as a file using git blob tags.

```yaml
Type: SwitchParameter
Parameter Sets: Checkout
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version

Specifies the version to checkout as a file. This parameter is required when using the `-Checkout` parameter.

```yaml
Type: Version
Parameter Sets: Checkout
Aliases:

Required: True
Position: Named
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
