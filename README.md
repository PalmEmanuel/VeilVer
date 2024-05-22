# VeilVer - Hidden Git File Versioning

<img src="./images/VeilVer.png" width="256">

[![VeilVer]][VeilVerGallery] [![VeilVerDownloads]][VeilVerGallery]

The VeilVer PowerShell module provides commands to set and get hidden versions with metadata for files within a git repository using git blob tags.

## Installation

The module is on PowerShell Gallery and can easily be installed like other modules.

```powershell
Install-Module -Name VeilVer
```

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

### Remove-VVVersion

Removes a specific version from a file.

```powershell
Remove-VVVersion -Path <path/to/document> -Version <semantic-version>
```

```powershell
Remove-VVVersion -Tag <full-git-tag>
```

<!-- References -->
[VeilVerDownloads]: https://img.shields.io/powershellgallery/dt/VeilVer
[VeilVerGallery]: https://www.powershellgallery.com/packages/VeilVer/
[VeilVer]: https://img.shields.io/powershellgallery/v/VeilVer?label=VeilVer
