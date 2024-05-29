function Import-VVVersion {
    [Alias('Pull-VVVersion')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Tag')]
        [ValidatePattern('^@VV', ErrorMessage = 'Tag must start with the prefix "@VV".')]
        [string]$Tag,

        [Parameter(ParameterSetName = 'Tag')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string]$Remote = 'origin',

        [Parameter(ParameterSetName = 'Tag')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$Force
    )

    # Get all VeilVer tags from the git remote
    $RemoteTags = Invoke-GitCommand 'ls-remote', '--tags', $Remote, 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') } | ForEach-Object { $_.Split("`t")[-1] }

    if ($PSCmdlet.MyInvocation.BoundParameters.ContainsKey('Tag') -and $RemoteTags -notcontains "refs/tags/$Tag") {
        throw "The tag '$Tag' does not exist on the remote '$Remote'."
    }

    # Get all VeilVer tags from the local git repository
    $LocalTags = Invoke-GitCommand 'tag', '--list', '@VV*'

    $NewRemoteTags = $RemoteTags | ForEach-Object { $_.TrimStart('refs/tags/') } | Where-Object { $_ -notin $LocalTags }

    switch ($PSCmdlet.ParameterSetName) {
        'All' {
            # Fetch all VeilVer tags from the git remote
            # Overwrite local different tags with the same name if -Force is specified
            $Pattern = $Force.IsPresent ? '+refs/tags/@VV*:refs/tags/@VV*' : 'refs/tags/@VV*:refs/tags/@VV*'
            $null = Invoke-GitCommand 'fetch', $Remote, $Pattern, '--quiet'

            if ($NewRemoteTags.Count -eq 0) {
                Write-Warning "No new hidden version tags found on the remote '$Remote'."
                return
            }

            Write-Verbose @"
Fetched the following hidden version tag(s):
- $($NewRemoteTags -join "`n- ")
"@
        }
        'Tag' {
            # Overwrite local tags with the same name if -Force is specified
            $Pattern = $Force.IsPresent ? "+refs/tags/${Tag}:refs/tags/${Tag}" : "refs/tags/${Tag}:refs/tags/${Tag}"

            $null = Invoke-GitCommand 'fetch', $Remote, $Pattern, '--quiet'

            Write-Verbose "Fetched the hidden version tag '$Tag' from the remote '$Remote'."
        }
    }
}