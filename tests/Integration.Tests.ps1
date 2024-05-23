Describe "Integration Tests for Get- and Set-VVVersion" {
    BeforeAll {
        # Set up a temporary git repository before tests
        Set-Location -Path $TestDrive
        git init

        # Needs to be set for the commit to work on all platforms in pipeline
        git config user.name "VeilVer"
        git config user.email "veilver@pipe.how"

        # Create a new file in the temporary repository
        $FileName = "testfile.txt"
        $FilePath = Join-Path -Path $TestDrive -ChildPath $FileName
        Set-Content -Path $FilePath -Value "Test content"
        git add .
        git commit -m "Initial commit with test file"

        $SpecialCharacters = '!"#€%&/()=?`_:;*^©@£$∞§|[]≈±´\{}¡¥≠}¢¿@•Ωé®†µüıœπ˙æøﬁªß∂ƒ√ª˛ƒ∂ﬁßåäöÅÄÖ'
    }

    It "Creates versions using Set-VVVersion" {
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

    It "Checks out a version as a file using the -Checkout parameter" {
        # Create a new version with specific content
        $VersionContent = "This is a specific version content."
        Set-Content -Path $FilePath -Value $VersionContent
        git add .
        git commit -m "Committing specific version content"
        Set-VVVersion -Path $FilePath -Version "2.0.0" -Metadata @{ Description = "Specific version for checkout test" }

        # Checkout the version using the -Checkout parameter
        Get-VVVersion -Path $FilePath -Checkout -Version "2.0.0"

        # Verify the file content matches the specific version content
        $FileContent = Get-Content -Path $FilePath
        $FileContent | Should -Be $VersionContent
    }
}
