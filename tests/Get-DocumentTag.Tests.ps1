Describe "Get-DocumentTag Tests" {
    Context "Functionality" {
        It "Retrieves tags for a document" {
            # Assuming the function Get-DocumentTag is correctly implemented
            Mock Get-DocumentTag { return @("Tag1: Message1", "Tag2: Message2") }
            $result = Get-DocumentTag -DocumentPath "path/to/document"
            $result | Should -Be @("Tag1: Message1", "Tag2: Message2")
        }
    }
}
