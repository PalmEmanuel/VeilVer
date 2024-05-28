function Import-VVVersion {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'Tag')]
        [ValidatePattern('^@VV', ErrorMessage = 'Tag must start with the prefix "@VV".')]
        [string]$Tag,

        [Parameter(ParameterSetName = 'Tag')]
        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string]$Remote = 'origin',

        [Parameter(ParameterSetName = 'All')]
        [switch]$All = $true,

        [Parameter(ParameterSetName = 'Tag')]
        [Parameter(ParameterSetName = 'All')]
        [switch]$Force
    )

    if ($PSCmdlet.ParameterSetName -eq 'All' -and -not $All.IsPresent) {
        throw 'Invalid parameter combination. Either specify the -Tag parameter or use the -All switch.'
    }

    # Get all VeilVer tags from the git remote
    $RemoteTags = Invoke-GitCommand 'ls-remote', '--tags', $Remote, 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') } | ForEach-Object { $_.Split("`t")[-1] }
    
    if ($All.IsPresent) {
        # Fetch all VeilVer tags from the git remote
        if ($Force.IsPresent) {
            # Overwrite local tags with the same name
            $null = Invoke-GitCommand 'fetch', $Remote, '+refs/tags/@VV*:refs/tags/@VV*', '--quiet'
        }
        else {
            $null = Invoke-GitCommand 'fetch', $Remote, 'refs/tags/@VV*:refs/tags/@VV*', '--quiet'
        }

        Write-Verbose @"
Fetched the following hidden version tag(s):
- $(($RemoteTags | ForEach-Object { $_.TrimStart('refs/tags/') }) -join "`n- ")
"@
    }
    else {
        if ($RemoteTags -notcontains "refs/tags/$Tag") {
            throw "The tag '$Tag' does not exist on the remote '$Remote'."
        }
        if ($Force.IsPresent) {
            # Overwrite local tags with the same name
            $null = Invoke-GitCommand 'fetch', $Remote, "+refs/tags/${Tag}:refs/tags/${Tag}", '--quiet'
        }
        else {
            $null = Invoke-GitCommand 'fetch', $Remote, "refs/tags/${Tag}:refs/tags/${Tag}", '--quiet'
        }
        Write-Verbose "Fetched the hidden version tag '$Tag' from the remote '$Remote'."
    }
}