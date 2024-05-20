# VeilVer PowerShell Module

The VeilVer PowerShell module provides commands to set and get metadata for documents within a repository using git tags. This functionality is particularly useful for managing document versions and metadata in a structured and accessible manner.

## Commands

### Set-DocumentTag

Sets or updates a git tag for a document with specified metadata.

```powershell
Set-DocumentTag -DocumentPath <path/to/document> -TagName <tag-name> -TagMessage <message> -Author <author-name>
```

### Get-DocumentTag

Retrieves git tags and their associated messages for a document.

```powershell
Get-DocumentTag -DocumentPath <path/to/document>
```

## Examples

### Setting a Document Tag

To set a tag for `docs/Contoso/MyDoc1.md` with version 1.0.2 by Emanuel:

```powershell
Set-DocumentTag -DocumentPath ./docs/Contoso/MyDoc1.md -TagName "contoso/MyDoc1/v1.0.2" -TagMessage "Updated MyDoc1.md" -Author "Emanuel"
```

### Getting Document Tags

To get all tags for `docs/Contoso/MyDoc1.md`:

```powershell
Get-DocumentTag -DocumentPath ./docs/Contoso/MyDoc1.md
```

## Demo Documents

Demo documents for testing VeilVer module commands can be found in the `VeilVer/Demo/docs` directory. This includes documents for both Contoso and Fabrikam examples.
