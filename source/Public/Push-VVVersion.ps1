function Push-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [ValidateNotNullOrEmpty()]
        [version]$Version,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Tag')]
        [ValidatePattern('^@VV', ErrorMessage = 'Tag must start with the prefix "@VV".')]
        [string]$Tag,

        [Parameter(ParameterSetName = 'Tag')]
        [Parameter(ParameterSetName = 'Path')]
        [ValidateNotNullOrEmpty()]
        [string]$Remote = (Get-GitBranchDefaultRemote)
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Path' {
            $Tag = (Get-VVVersion -Path $Path -Version $Version).Tag
        }
    }

    # Push the tag to the git remote
    $null = Invoke-GitCommand 'push', $Remote, 'tag', $Tag, '--quiet'

    Write-Verbose "Pushed tag '$Tag' to remote '$Remote'."
}