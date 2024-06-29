function Get-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Path')]
        [Parameter(Mandatory, ParameterSetName = 'Checkout')]
        [ValidateScript({ Test-Path $_ -PathType Leaf }, ErrorMessage = 'Path must exist and be a file.')]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'Path')]
        [Parameter(Mandatory, ParameterSetName = 'Checkout')]
        [ValidateNotNullOrEmpty()]
        [version]$Version,

        [Parameter(Mandatory, ParameterSetName = 'Checkout')]
        [switch]$Checkout,

        [Parameter(ParameterSetName = 'Checkout')]
        [switch]$Force,

        [Parameter(ParameterSetName = 'All')]
        [switch]$All
    )

    if ($All.IsPresent) {
        $Tags = Get-GitBlobTag -All
        $Paths = $Tags | ForEach-Object { [Regex]::Match($_.Tag,'^@VV/(?<file>.*)/v[\d.]+$').Groups['file'].Value } | Select-Object -Unique
        $Paths | ForEach-Object { Get-VVVersion -Path $_ -ErrorAction SilentlyContinue } | Write-Output
        return
    }

    # Get all tags based on file names
    $FileNames = Get-GitFileHistoryNames -Path $Path
    
    $Tags = $FileNames | ForEach-Object {
        Get-GitBlobTag -RelativeRootPath $_
    }

    if ($Tags.Count -eq 0) {
        Write-Warning "No hidden version tags found for the file '$Path'."
        return
    }

    # If a version is specified, return the tag with the version
    if ($null -ne $Version -and -not $Checkout.IsPresent) {
        $TagInfo = $Tags | Where-Object Version -eq $Version
        if ($null -eq $TagInfo) {
            throw "The specified version '$Version' of file '$Path' does not exist."
        }
        return $TagInfo
    }

    # If checkout is specified, checkout the version
    if ($Checkout.IsPresent) {
        if ((Test-GitFileIsModified -Path $Path) -and -not $Force.IsPresent) {
            throw "The file '$Path' has been modified. Please commit or discard the changes before checking out a version, or override the file using the -Force parameter."
        }

        $TagInfo = $Tags | Where-Object Version -eq $Version
        
        if ($null -eq $TagInfo) {
            throw "The specified version '$Version' of file '$Path' does not exist."
        }

        $FileContent = Invoke-GitCommand 'show', $TagInfo.Hash
        Set-Content -Path $Path -Value $FileContent -Force:$Force.IsPresent
        Write-Verbose "Checked out version '$Version' of '$Path' successfully."
        return
    }

    # Return all tags if no version is specified
    Write-Output $Tags
}
