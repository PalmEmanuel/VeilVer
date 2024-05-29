function Remove-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [version]$Version,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Tag')]
        [string]$Tag
    )

    # If parameter set name
    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        # Get all tags based on file names
        $FileNames = Get-GitFileHistoryNames -Path $Path

        $Tags = $FileNames | ForEach-Object {
            Get-GitBlobTag -RelativeRootPath $_
        }

        $Tag = $Tags | Where-Object { $_.Version -eq $Version } | Select-Object -ExpandProperty Tag
        
        if ($null -eq $Tag) {
            Write-Warning "No hidden version tags found for the file '$Path' with version '$Version'."
            return
        }
    }

    try {
        Remove-GitBlobTag -Tag $Tag -ErrorAction Stop
    
        Write-Verbose "Successfully removed the hidden version tag '$Tag'."
    }
    catch {
        throw "Failed to remove the hidden version tag '$Tag'."
    }
}