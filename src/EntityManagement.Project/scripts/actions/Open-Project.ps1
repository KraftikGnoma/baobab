#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: Open-Project.ps1
# Description: 
#   Runs the open script of the project.
#   The open script must be '<project root>\auto\open.ps1'
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

$openScript = "$entityRoot\auto\open.ps1"
if (Test-Path $openScript)
{
	& $openScript -scriptRoot $scriptRoot -entityRoot $entityRoot
}
else
{
	[Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
	[Windows.Forms.MessageBox]::Show( `
		"The project specific open script 'open.ps1' was not found.`n`t$openScript", `
		"Open project", `
		"Ok", "Error" )
}

Write-Verbose "--- $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"
