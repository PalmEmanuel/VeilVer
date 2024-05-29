---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Remove-VVVersion

## SYNOPSIS

Remove a specific version from a file.

## SYNTAX

### FileVersion (Default)
```
Remove-VVVersion -Path <String> -Version <Version> [<CommonParameters>]
```

### Tag
```
Remove-VVVersion -Tag <String> [<CommonParameters>]
```

## DESCRIPTION

Remove a specific version from a file.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-VVVersion -Path "C:\path\to\document.md" -Version 1.0.0
```

Remove the version 1.0.0 from the file at the specified path.

## PARAMETERS

### -Path

The path to the file to remove the hidden version from.

```yaml
Type: String
Parameter Sets: FileVersion
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Tag

The full version tag to remove, instead of a specific file and version, such as "@VV/path/to/file/v1.0.0"

```yaml
Type: String
Parameter Sets: Tag
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Version

The version to remove from the file.

```yaml
Type: Version
Parameter Sets: FileVersion
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
