Describe "Integration Tests" {
    BeforeAll {
        # Need to set user config for the commits to work on all platforms in pipeline
        git config --global user.name "VeilVer"
        git config --global user.email "veilver@pipe.how"
        # Set default branch name
        git config --global init.defaultBranch main

        # Set up a temporary git repositories before tests
        # Repo2 is the remote "origin"
        # Repo1 is the clone
        $Repo1 = "$TestDrive/repo1.git"
        $Repo2 = "$TestDrive/repo2.git"
        New-Item -ItemType Directory -Path $Repo1 -Force
        New-Item -ItemType Directory -Path $Repo2 -Force
        git init --bare $Repo2 --quiet
        $null = git clone $Repo2 $Repo1 2>&1
        Set-Location $Repo1

        # Create a new file in the temporary repository
        $FileName = "testfile.txt"
        $FilePath = Join-Path -Path $Repo1 -ChildPath $FileName
        Set-Content -Path $FilePath -Value "Test content"
        git add .
        git commit -m "Initial commit with test file"
        git push --quiet
        
        $SpecialCharacters = '!"#€%&/()=?`_:;*^©@£$∞§|[]≈±´\{}¡¥≠}¢¿@•Ωé®†µüıœπ˙æøﬁªß∂ƒ√ª˛ƒ∂ﬁßåäöÅÄÖ'
        $MetadataHash = @{
            "Author" = "Emanuel Palm"
            "Description" = "Testing the commands"
            "Feature" = "N/A"
            "ReviewedBy" = "None"
            "ApprovedBy" = "Approver1"
            "Tested" = $true
            "Passed" = $true
            "Category" = "IntegrationTest"
            "Priority" = "High"
            "ReleaseDate" = "2024-05-21"
            "SpecialCharacters" = $SpecialCharacters
        }
    }

    It "Creates versions using Set-VVVersion" {
        { Set-VVVersion -Path $FilePath -Version "1.0.0" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.2.3" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.10.1" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.1.1" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
    }

    It "Retrieves versions in the right order using Get-VVVersion" {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 4
        # Versions should be in descending version order, regardless of creation order
        $Versions[0].Version.ToString() | Should -Be "1.10.1"
        $Versions[1].Version.ToString() | Should -Be "1.2.3"
        $Versions[2].Version.ToString() | Should -Be "1.1.1"
        $Versions[3].Version.ToString() | Should -Be "1.0.0"
    }

    It "Retrieves versions with correct information using Get-VVVersion" {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions[0].Metadata.SpecialCharacters | Should -Be $SpecialCharacters
        $Versions[0].Metadata.Commit | Should -Be (git rev-parse --verify HEAD)
    }

    It "Removes versions using Remove-VVVersion using Path and Version" {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 4
        Remove-VVVersion -Path $FilePath -Version "1.0.0"
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 3
    }

    It "Removes versions using Remove-VVVersion using Tag" {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 3
        Remove-VVVersion -Tag $Versions[1].Tag
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 2
    }

    It "Checks out a file version with a commit using the -Checkout parameter" {
        # Create a new version with specific content
        $Version2Content = "This is a specific version 2 content."
        $Version3Content = "This is a specific version 3 content."

        Set-Content -Path $FilePath -Value $Version2Content
        git add .
        git commit -m "Committing version 2"
        Set-VVVersion -Path $FilePath -Version "2.0.0" -Metadata @{ Description = "Specific version 2 for checkout test" }
        
        Set-Content -Path $FilePath -Value $Version3Content
        git add .
        git commit -m "Committing version 3"
        Set-VVVersion -Path $FilePath -Version "3.0.0" -Metadata @{ Description = "Specific version 3 for checkout test" }
        
        # Verify the file content matches the specific version content before checkout
        Get-Content -Path $FilePath | Should -Be $Version3Content

        # Checkout the version using the -Checkout parameter
        Get-VVVersion -Path $FilePath -Checkout -Version "2.0.0"

        # Verify the file content matches the specific version content after checkout
        Get-Content -Path $FilePath | Should -Be $Version2Content
    }

    It 'Can Push a version to a default remote with Path and Version' {
        # First make sure that the remote has the same commits
        git push origin main --quiet --no-progress
        git push origin --tags --quiet --no-progress
        git reset HEAD --hard
        $RemoteTagsCountBefore = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        Set-VVVersion -Path $FilePath -Version "4.0.0" -Metadata $MetadataHash -WarningAction SilentlyContinue
        { Push-VVVersion -Path $FilePath -Version "4.0.0" } | Should -Not -Throw
        
        $RemoteTagsCountAfter = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        $RemoteTagsCountAfter | Should -BeExactly ($RemoteTagsCountBefore + 1)
    }

    It 'Can Push a version to a specific remote with Tag' {
        # First make sure that the remote has the same commits
        git push origin main --quiet --no-progress
        git push origin --tags --quiet --no-progress
        git reset HEAD --hard
        $RemoteTagsCountBefore = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        Set-VVVersion -Path $FilePath -Version "5.0.0" -Metadata $MetadataHash -WarningAction SilentlyContinue
        { Push-VVVersion -Tag "@VV/$FileName/v5.0.0" -Remote "origin" } | Should -Not -Throw
        
        $RemoteTagsCountAfter = (git ls-remote --tags origin 'refs/tags/@VV*' | Where-Object { -not $_.EndsWith('^{}') }).Count

        $RemoteTagsCountAfter | Should -BeExactly ($RemoteTagsCountBefore + 1)
    }
}
