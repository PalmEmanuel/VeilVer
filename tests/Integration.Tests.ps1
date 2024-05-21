BeforeAll {
    # Set up a temporary git repository before tests
    Set-Location -Path $TestDrive
    git init
}

Describe "Integration Tests for Get- and Set-VVVersion" {
    BeforeAll {
        # Create a new file in the temporary repository
        $FilePath = Join-Path -Path $TestDrive -ChildPath "testfile.txt"
        Set-Content -Path $FilePath -Value "Test content"
        git add .
        git commit -m "Initial commit with test file"
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
            "ExtraCharacters" = '!"#€%&/()=?`_:;*^©@£$∞§|[]≈±´\{}¡¥≠}¢¿@•Ωé®†µüıœπ˙æøﬁªß∂ƒ√ª˛ƒ∂ﬁßåäöÅÄÖ'
        }
        { Set-VVVersion -Path $FilePath -Version "1.0.0" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.2.3" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.10.1" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
        { Set-VVVersion -Path $FilePath -Version "1.1.1" -Metadata $MetadataHash -WarningAction SilentlyContinue } | Should -Not -Throw
    }

    It "Retrieves versions using Get-VVVersion" {
        $Versions = Get-VVVersion -Path $FilePath
        $Versions.Count | Should -Be 4
        # Versions should be in descending version order, regardless of creation order
        $Versions[0].Version.ToString() | Should -Be "1.10.1"
        $Versions[1].Version.ToString() | Should -Be "1.2.3"
        $Versions[2].Version.ToString() | Should -Be "1.1.1"
        $Versions[3].Version.ToString() | Should -Be "1.0.0"
        $Versions[0].Data.ExtraCharacters | Should -Be '!"#€%&/()=?`_:;*^©@£$∞§|[]≈±´\{}¡¥≠}¢¿@•Ωé®†µüıœπ˙æøﬁªß∂ƒ√ª˛ƒ∂ﬁßåäöÅÄÖ'
        $Versions[0].Data.Commit | Should -Be (git rev-parse --verify HEAD)
    }
}
