---
external help file: VeilVer-help.xml
Module Name: VeilVer
online version:
schema: 2.0.0
---

# Import-VVVersion

## SYNOPSIS

Pull all versions or a specific version from a remote git repository.

## SYNTAX

### All (Default)
```
Import-VVVersion [-Remote <String>] [-Force] [<CommonParameters>]
```

### Tag
```
Import-VVVersion -Tag <String> [-Remote <String>] [-Force]
 [<CommonParameters>]
```

## DESCRIPTION

Pull all versions or a specific version from a remote git repository.

## EXAMPLES

### Example 1
```powershell
PS C:\> Import-VVVersion
```

Pulls all versions from the remote repository to sync them to the local repository.

### Example 2
```powershell
PS C:\> Pull-VVVersion
```

Uses the alias `Pull-VVVersion` to pull all versions from the remote repository.

### Example 3
```powershell
PS C:\> Pull-VVVersion -Tag "@VV/path/to/file/v1.0.0"
```

Pulls the specific version `1.0.0` from the remote repository.

## PARAMETERS

### -Force

Overwrite different local versions with the same name(s).

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Remote

The remote repository to pull versions from, defaults to the default remote of the current git branch.

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

The specific version to pull from the remote repository.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable, -ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
