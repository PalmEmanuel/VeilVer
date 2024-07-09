function Remove-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'Tag', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$Path,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [version]$Version,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Tag')]
        [string[]]$Tag,

        [Parameter(ParameterSetName = 'Path')]
        [Parameter(ParameterSetName = 'Tag')]
        [switch]$Force
    )

    begin {
        if ($Force -and -not $Confirm) {
            $ConfirmPreference = 'None'
        }
    }

    process {
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

        foreach ($CurrentTag in $Tag) {
            try {
                if ($PSCmdlet.ShouldProcess($CurrentTag, 'Remove-VVVersion')) {
                    Remove-GitBlobTag -Tag $CurrentTag -ErrorAction Stop
        
                    Write-Verbose "Successfully removed the hidden version tag '$CurrentTag'."
                }
            }
            catch {
                throw "Failed to remove the hidden version tag '$CurrentTag'."
            }
        }
    }
}