BeforeAll {
    function NewGitRepo {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [ValidatePattern('\.git$', ErrorMessage = 'Name must end with ".git".')]
            [string]$Path,

            [Parameter()]
            [switch]$Bare
        )

        New-Item -ItemType Directory -Path $Path -Force
        git config init.defaultBranch main
    
        if ($Bare.IsPresent) {
            git init --bare $Path --quiet
        }
        else {
            git init $Path --quiet
        }

        Push-Location $Path
        SetGitConfig
        Pop-Location
    }
    function SetGitConfig {
        [CmdletBinding()]
        param()

        git config user.name 'VeilVer'
        git config user.email 'veilver@pipe.how'
    }
    function CloneGitRepo {
        [CmdletBinding()]
        param(
            [Parameter(Mandatory)]
            [ValidatePattern('\.git$', ErrorMessage = 'Name must end with ".git".')]
            [string]$Path,

            [Parameter()]
            [string]$DestinationPath
        )
    
        New-Item -ItemType Directory -Path $DestinationPath -Force

        SetGitConfig

        $null = git clone $Path $DestinationPath 2>&1

        Push-Location $DestinationPath

        SetGitConfig
        SeedGitRepoFiles

        Pop-Location
    }

    function SeedGitRepoFiles {
        [CmdletBinding()]
        param()
    
        1..5 | ForEach-Object {
            $TempFileName = "File$_.txt"
            New-Item -Name $TempFileName -Value "Number $_"
            git add $TempFileName
            git commit -m "File $_ added"
            1..5 | ForEach-Object {
                Add-Content -Path "./$TempFileName" -Value ", then $_"
                git add $TempFileName
                git commit -m "Number $_ added to $TempFileName"
            }
        }
    
        git push --quiet
    }
}

Describe 'Integration Tests' {
    
    BeforeAll {
        # Set up a temporary git repositories before tests
        $LocalRepoPath = "$TestDrive/local.git"
        $OriginRepoPath = "$TestDrive/origin.git"
        
        # Safety in case the code is run outside of Pester
        if (-not [string]::IsNullOrWhiteSpace($TestDrive)) {
            Remove-Item -Path $OriginRepoPath -Recurse -Force -ErrorAction SilentlyContinue
            Remove-Item -Path $LocalRepoPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        NewGitRepo -Path $OriginRepoPath -Bare
        CloneGitRepo -Path $OriginRepoPath $LocalRepoPath
        
        $SpecialCharacters = '!"#€%&/()=?`_:;*^©@£$∞§|[]≈±´\{}¡¥≠}¢¿@•Ωé®†µüıœπ˙æøﬁªß∂ƒ√ª˛ƒ∂ﬁßåäöÅÄÖ'
        $MetadataHash = @{
            'Author'            = 'Emanuel Palm'
            'Description'       = 'Testing the commands'
            'Feature'           = 'N/A'
            'ReviewedBy'        = 'None'
            'ApprovedBy'        = 'Approver1'
            'Tested'            = $true
            'Passed'            = $true
            'Category'          = 'IntegrationTest'
            'Priority'          = 'High'
            'ReleaseDate'       = '2024-05-21'
            'SpecialCharacters' = $SpecialCharacters
        }
    }
    
    BeforeEach {
        Set-Location $LocalRepoPath

        $File = (Get-ChildItem '*.txt')[0]
        $FilePath = $File.FullName
        $FileName = $File.Name
    }
    
    It 'Creates versions using Set-VVVersion' {
        { Set-VVVersion -Path $FilePath -Version '1.0.0' -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version '1.2.3' -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version '1.10.1' -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version '1.1.1' -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
    }

    It 'Retrieves versions in the right order using Get-VVVersion' {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 4
        # Versions should be in descending version order, regardless of creation order
        $Versions[0].Version.ToString() | Should -Be '1.10.1'
        $Versions[1].Version.ToString() | Should -Be '1.2.3'
        $Versions[2].Version.ToString() | Should -Be '1.1.1'
        $Versions[3].Version.ToString() | Should -Be '1.0.0'
    }

    It 'Retrieves versions with correct information using Get-VVVersion' {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions[0].Metadata.SpecialCharacters | Should -Be $SpecialCharacters
        $Versions[0].Metadata.Commit | Should -Be (git rev-parse --verify HEAD)
    }

    It 'Removes versions using Remove-VVVersion using Path and Version' {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 4
        Remove-VVVersion -Path $FilePath -Version '1.0.0'
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 3
    }

    It 'Removes versions using Remove-VVVersion using Tag' {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 3
        Remove-VVVersion -Tag $Versions[1].Tag
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 2
    }

    It 'Checks out a file version with a commit using the -Checkout parameter' {
        # Create a new version with specific content
        $Version2Content = 'This is a specific version 2 content.'
        $Version3Content = 'This is a specific version 3 content.'

        Set-Content -Path $FilePath -Value $Version2Content
        git add .
        git commit -m 'Committing version 2'
        Set-VVVersion -Path $FilePath -Version '2.0.0' -Metadata @{ Description = 'Specific version 2 for checkout test' }
        
        Set-Content -Path $FilePath -Value $Version3Content
        git add .
        git commit -m 'Committing version 3'
        Set-VVVersion -Path $FilePath -Version '3.0.0' -Metadata @{ Description = 'Specific version 3 for checkout test' }
        
        # Verify the file content matches the specific version content before checkout
        Get-Content -Path $FilePath | Should -Be $Version3Content

        # Checkout the version using the -Checkout parameter
        Get-VVVersion -Path $FilePath -Checkout -Version '2.0.0'

        # Verify the file content matches the specific version content after checkout
        Get-Content -Path $FilePath | Should -Be $Version2Content
    }

    It 'Can Push a version to a default remote with Path and Version' {
        # First make sure that the remote has the same commits
        git push origin main --quiet --no-progress
        git push origin --tags --quiet --no-progress
        git reset HEAD --hard
        $RemoteTagsCountBefore = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        Set-VVVersion -Path $FilePath -Version '4.0.0' -Metadata $MetadataHash -WarningAction SilentlyContinue
        { Push-VVVersion -Path $FilePath -Version '4.0.0' } | Should -Not -Throw
        
        $RemoteTagsCountAfter = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        $RemoteTagsCountAfter | Should -BeExactly ($RemoteTagsCountBefore + 1)
    }

    It 'Can Push a version to a specific remote with Tag' {
        # First make sure that the remote has the same commits
        git push origin main --quiet --no-progress
        git push origin --tags --quiet --no-progress
        git reset HEAD --hard
        $RemoteTagsCountBefore = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        Set-VVVersion -Path $FilePath -Version '5.0.0' -Metadata $MetadataHash -WarningAction SilentlyContinue
        { Push-VVVersion -Tag "@VV/$FileName/v5.0.0" -Remote 'origin' } | Should -Not -Throw
        
        $RemoteTagsCountAfter = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        $RemoteTagsCountAfter | Should -BeExactly ($RemoteTagsCountBefore + 1)
    }

    It 'Can sync tag names for a renamed file using Sync-VVVersion' {
        # Setup new file name
        $NewFileName = 'renamed_testfile.txt'
        $NewFilePath = Join-Path -Path $LocalRepoPath -ChildPath $NewFileName
        
        # Ensure current file name doesn't contain new name
        $VersionsBeforeRename = Get-VVVersion -Path $FilePath
        $VersionsBeforeRename.Path | Should -Not -Contain $NewFileName

        Rename-Item -Path $FilePath -NewName $NewFileName

        git add $NewFilePath
        git commit -m 'added new version'

        # Use Sync-VVVersion to update tags
        { Sync-VVVersion -Path $NewFilePath -WarningAction SilentlyContinue } | Should -Not -Throw

        # Verify tags are updated
        $VersionsAfterRename = Get-VVVersion -Path $NewFilePath
        $VersionsAfterRename.Count | Should -Be $VersionsBeforeRename.Count
        $VersionsAfterRename.Path | Should -Contain $NewFileName
    }
}
