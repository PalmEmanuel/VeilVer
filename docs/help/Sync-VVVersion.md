---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Sync-VVVersion

## SYNOPSIS

Renames all historic versions for a file to its current file name and path.

## SYNTAX

```
Sync-VVVersion [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION

Renames all historic version tags for a file to its current file name and path.

## EXAMPLES

### Example 1
```powershell
PS C:\> Sync-VVVersion -FilePath "C:\path\to\new\document.md"
```

This example updates all versions for the file at "C:\path\to\new\document.md" to reflect its current file path, assuming it has been renamed from a previous path.

## PARAMETERS

### -Path

The path of the file to rename all tags for.

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
