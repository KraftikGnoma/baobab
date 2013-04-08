#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: Build-Project.ps1
# Description: 
#   Runs the build script of the project documentation.
#   The build script must be '<project root>\auto\builddoc.ps1'
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

$buildScript = "$entityRoot\auto\builddoc.ps1"
if (Test-Path $buildScript)
{
	& $buildScript `
		-scriptRoot $scriptRoot `
		-entityRoot $entityRoot
}
else
{
	[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	[Windows.Forms.MessageBox]::Show( `
		"The project specific documentation build script 'builddoc.ps1' was not found.`n`t$buildScript", `
		"Build project", `
		"Ok", "Error" )
}

Write-Verbose "--- $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"
