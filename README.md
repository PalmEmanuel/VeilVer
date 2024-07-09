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

The module provides the following commands:

- `Get-VVVersion` to get hidden versions of a file.
- `Clear-VVVersion` to remove all hidden versions of a file.
- `Import-VVVersion` to pull versions from a remote repository.
- `Push-VVVersion` to push versions to a remote repository.
- `Remove-VVVersion` to remove a hidden version from a file.
- `Set-VVVersion` to set a hidden version of a file.
- `Update-VVVersion` to update all hidden versions of a file to its current path.

<!-- References -->
[VeilVerDownloads]: https://img.shields.io/powershellgallery/dt/VeilVer
[VeilVerGallery]: https://www.powershellgallery.com/packages/VeilVer/
[VeilVer]: https://img.shields.io/powershellgallery/v/VeilVer?label=VeilVer
