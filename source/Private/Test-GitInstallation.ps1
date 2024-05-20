function Test-GitInstallation {
    [CmdletBinding()]
    param()

    if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
        throw 'No installation of git was found, please install git to use this module.'
    }
}