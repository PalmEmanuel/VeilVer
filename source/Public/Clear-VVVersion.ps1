function Clear-VVVersion {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path $_ -IsValid }, ErrorMessage = 'Must be a valid path format, but does not need to exist (anymore).')]
        [string]$Path,

        [Parameter()]
        [switch]$Force
    )

    begin {
        if ($Force -and -not $Confirm){
            $ConfirmPreference = 'None'
        }
    }

    process {
        $Versions = Get-VVVersion -Path $Path
        
        if ($null -ne $Versions) {
            $Versions.Tag | ForEach-Object {
                if ($PSCmdlet.ShouldProcess($_, 'Remove-VVVersion')) {
                    Remove-VVVersion -Tag $_
                }
            }
        }
        else {
            Write-Verbose "No hidden version tags found for the path '$Path'."
        }
    }
}