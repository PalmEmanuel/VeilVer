Describe "Rename-VVVersion Command Tests" {
    BeforeAll {
        # Mocking git commands to isolate testing environment
        Mock Invoke-GitCommand { return $null }
    }

    Context "Validating FilePath Parameter" {
        It "Throws an error if the FilePath does not exist" {
            { Rename-VVVersion -FilePath "NonExistentPath" } | Should -Throw -ExpectedMessage "File path 'NonExistentPath' does not exist."
        }
    }

    Context "Renaming Git Tags" {
        It "Correctly updates git tags for a file's historical names" {
            Mock Get-GitFileHistoryNames { return @("old/path/document.md", "new/path/document.md") }
            Mock Get-GitBlobTags { return @(@{ File = "old/path/document.md"; Tag = "v1.0"; Version = "1.0.0"; Metadata = @{ Author = "Test" } }) }
            Mock Remove-VVVersion {}
            Mock Set-VVVersion {}

            { Rename-VVVersion -FilePath "new/path/document.md" } | Should -Not -Throw
            Assert-MockCalled Remove-VVVersion -Times 1 -Exactly
            Assert-MockCalled Set-VVVersion -Times 1 -Exactly
        }

        It "Does not update tags if the file path has not changed" {
            Mock Get-GitFileHistoryNames { return @("current/path/document.md") }
            Mock Get-GitBlobTags { return @(@{ File = "current/path/document.md"; Tag = "v1.0"; Version = "1.0.0"; Metadata = @{ Author = "Test" } }) }
            Mock Remove-VVVersion {}
            Mock Set-VVVersion {}

            { Rename-VVVersion -FilePath "current/path/document.md" } | Should -Not -Throw
            Assert-MockCalled Remove-VVVersion -Times 0 -Exactly
            Assert-MockCalled Set-VVVersion -Times 0 -Exactly
        }
    }

    Context "Error Handling and Invalid Input" {
        It "Handles invalid version format gracefully" {
            Mock Get-GitFileHistoryNames { return @("path/document.md") }
            Mock Get-GitBlobTags { return @(@{ File = "path/document.md"; Tag = "invalidVersion"; Version = "invalid"; Metadata = @{ Author = "Test" } }) }
            Mock Remove-VVVersion {}
            Mock Set-VVVersion {}

            { Rename-VVVersion -FilePath "path/document.md" } | Should -Not -Throw
            Assert-MockCalled Remove-VVVersion -Times 0 -Exactly
            Assert-MockCalled Set-VVVersion -Times 0 -Exactly
        }
    }
}
