#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: Run-Project.ps1
# Description: 
#   Calls the run script of the project.
#   The run script must be '<project root>\scripts\run.ps1'
# Parameter: 
#   - entityRoot: 
#       Path to the root of the entity
#       Default value: Current working directory
# Dependencies: 
#   System.Windows.Forms
#=============================================================================

param (
    [string]$entityRoot = $(Get-Location)
)

Write-Verbose "+++ $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"

$myDir = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$scriptRoot = [IO.Path]::GetDirectoryName($myDir)

$entityRoot = [IO.Path]::GetFullPath($entityRoot)
if (-not (Test-Path $entityRoot))
{
	throw "The project directory does not exist:`n`t$entityDir"
}

$runScript = "$entityRoot\scripts\run.ps1"
if (Test-Path $runScript)
{
	& $runScript `
		-scriptRoot $scriptRoot`
		-entityRoot $entityRoot
}
else
{
	[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	[Windows.Forms.MessageBox]::Show( `
		"The project specific run script was not found.`n`t$runScript", `
		"Run project", `
		"Ok", "Error" )
}

Write-Verbose "--- $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"
