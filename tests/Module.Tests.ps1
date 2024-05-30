BeforeDiscovery {
    $ModuleName = Get-SamplerProjectName -BuildRoot $BuildRoot

    # Get exported commands
    $ExportedCommands = (Get-Module $ModuleName).ExportedCommands.Keys

    # Set up testcases
    $CommandTestCases = @()
    $ParametersTestCases = @()
    # Get custom parameters of all exported commands
    foreach ($Command in $ExportedCommands) {
        $CurrentCommand = Get-Command $Command
        if ($CurrentCommand.CommandType -eq 'Alias') {
            continue
        }
        $Parameters = $CurrentCommand.Parameters.GetEnumerator() | Where-Object {
            $_.Key -notin [System.Management.Automation.Cmdlet]::CommonParameters -and
            $_.Value.Attributes.DontShow -eq $false
        } | Select-Object -ExpandProperty Key

        foreach ($Parameter in $Parameters) {
            $ParametersTestCases += @{
                Command   = $Command
                Parameter = $Parameter
            }
        }

        $CommandTestCases += @{
            Command = $Command
        }
    }
}

BeforeAll {
    $ModuleName = Get-SamplerProjectName -BuildRoot $BuildRoot
}

Describe "$ModuleName" {
    # A module should always have exported commands
    Context 'module' {
        It 'does not use git directly in exported command <Command>' -TestCases $CommandTestCases {
            (Get-Command $Command).ScriptBlock.Ast.Body.FindAll({ 
                $args[0].StringConstantType -eq 'BareWord' -and $args[0].Value -eq 'git'
            }, $true) | Should -BeFalse
        }

        # Tests run on both uncompiled and compiled modules
        It 'has commands' -TestCases (@{ Count = $CommandTestCases.Count }) {
            $Count | Should -BeGreaterThan 0 -Because 'commands should exist'
        }
        
        It 'has no help file with empty documentation sections' {
            Get-ChildItem "$BuildRoot\docs\help\*.md" | Select-String '{{|}}' | Should -BeNullOrEmpty
        }
        
        It 'has command <Command> defined in file in the correct directory' -TestCases $CommandTestCases {
            (Get-ChildItem "$BuildRoot\source\*\$Command.ps1") | Should -Not -BeNullOrEmpty
        }

        It 'has test file for command <Command>' -TestCases $CommandTestCases {
            $Command
            
            "$BuildRoot\tests\$Command.Tests.ps1" | Should -Exist
        }

        It 'has markdown help file for command <Command>' -TestCases $CommandTestCases {
            "$BuildRoot\docs\help\$Command.md" | Should -Exist
        }

        It 'has parameter <Parameter> documented in markdown help file for command <Command>' -TestCases $ParametersTestCases {
            "$BuildRoot\docs\help\$Command.md" | Should -FileContentMatch $Parameter
        }
    }
}