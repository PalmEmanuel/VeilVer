---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Push-VVVersion

## SYNOPSIS

Pushes a version to a remote repository.

## SYNTAX

### Path (Default)
```
Push-VVVersion -Path <String> -Version <Version> [-Remote <String>]
 [<CommonParameters>]
```

### Tag
```
Push-VVVersion -Tag <String> [-Remote <String>] [<CommonParameters>]
```

## DESCRIPTION

Pushes a version to a remote repository.

## EXAMPLES

### Example 1
```powershell
PS C:\> Push-VVVersion -Path "path/to/file.md" -Version 1.0.0
```

Pushes the existing version 1.0.0 of the file to the remote repository.

### Example 2
```powershell
PS C:\> Push-VVVersion -Tag "@VV/path/to/file.md/v1.0.0"
```

Pushes the existing version 1.0.0 of the file to the remote repository using the tag.

## PARAMETERS

### -Path

The path to the file to push the hidden version for.

```yaml
Type: String
Parameter Sets: Path
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Remote

The remote repository to push the version to, defaults to the default remote of the current branch.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag

The full version tag to push, instead of a specific file and version, such as "@VV/path/to/file/v1.0.0"

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

The version of the file to push to the remote repository.

```yaml
Type: Version
Parameter Sets: Path
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

### System.String
### System.Version
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
