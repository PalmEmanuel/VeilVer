---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Rename-VVVersion

## SYNOPSIS

Renames all git tags for a file path to its current file name.

## SYNTAX

```
Rename-VVVersion [-FilePath] <String> [<CommonParameters>]
```

## DESCRIPTION

The `Rename-VVVersion` command updates all git tags associated with a file's historical names to match its current file name. It uses existing commands like `Get-GitBlobTags`, `Remove-VVVersion`, and `Set-VVVersion` to find, remove, and recreate tags with the updated file path.

## EXAMPLES

### Example 1
```powershell
PS C:\> Rename-VVVersion -FilePath "C:\path\to\new\document.md"
```

This example updates all git tags for the file at "C:\path\to\new\document.md" to reflect its current file name, assuming it has been renamed from a previous path.

## PARAMETERS

### -FilePath

Specifies the path to the file for which to update git tags.

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
