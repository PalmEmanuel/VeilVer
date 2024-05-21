# VeilVer - Hidden Git File Versioning

<img src="./images/veilver.png" width="256">

The VeilVer PowerShell module provides commands to set and get hidden versions with metadata for files within a repository using git blob tags.

## Commands

### Set-VVVersion

Sets or updates a git tag for a document with specified metadata.

```powershell
Set-VVVersion -Path <path/to/document> -Version <semantic-version> -Metadata <metadata-hashtable>
```

### Get-VVVersion

Retrieves git tags and their associated messages for a document.

```powershell
Get-VVVersion -Path <path/to/document>
```
