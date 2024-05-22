function Get-GitBlobTags {
    [CmdletBinding()]
    param (
        # Does not need to exist anymore, but must be a valid path
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$RelativeRootPath
    )

    # Example tag: VV/demo/docs/Contoso/Doc1.md/v1.0.0
    $TagPattern = "VV/$RelativeRootPath/v*"

    # Get tags with version data split by semicolon, sorted by version in descending order
    $Tags = Invoke-GitCommand 'tag', '--list', '--format=%(refname:short);%(contents)', '--sort=-version:refname', $TagPattern |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ForEach-Object {
            $Tag, $Base64Data = $_ -split ';'
            
            $TagVersionString = ($Tag -split '/')[-1].TrimStart('v')
            $TagVersion = [version]$TagVersionString

            # The tag command returns an empty line as part of the tag message, so we need to filter it out
            $JsonData = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Base64Data))
            $Metadata = $JsonData | ConvertFrom-Json

            [pscustomobject]@{
                'File' = $RelativeRootPath
                'Tag' = $Tag
                'Version' = $TagVersion
                'Metadata' = $Metadata
            }
        }

    if ($Tags.Count -eq 0) {
        return
    }

    Write-Verbose @"
Found the following hidden version tag(s) for the path '$RelativeRootPath':
- $(($Tags | ForEach-Object { $_.Version }) -join "`n- ")
"@

    Write-Output $Tags
}