#=============================================================================
# Project: Baobab
# Author: Daniel Kiertscher, Tobias Kiertscher
# Name: Set-DesktopAccess.ps1
# Description:
#   Activates and deactivates the access to the project via a link/shortcut
#   on the desktop, in 'My Documents' and in 'Favorites'.
# Parameter: 
#   - entityRoot: 
#       Path to the root of the entity
#       Default value: Current working directory
# Dependencies: 
#   Load-Assembly.ps1
#   FileSystemToolbox.dll
#=============================================================================

param (
  [string]$entityRoot = $(Get-Location)
)

Write-Verbose "+++ $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"

$myDir = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$scriptRoot = [IO.Path]::GetDirectoryName($myDir)
& "$scriptRoot\Load-Assembly.ps1" "FileSystemToolbox"

# check entityRoot
if (-not (Test-Path $entityRoot))
{
	throw "Could not find the target directory for the entity:`n`t$entityRoot"
}

$entityRoot = Resolve-Path $entityRoot

$entityName = [IO.Path]::GetFileName($entityRoot)
$arguments = "/root,`"$entityRoot`""
$icon = [IO.Path]::Combine($entityRoot, ".entity\icons\project.ico")

# prepare paths for the shortcuts
$links = "Desktop", "MyDocuments", "Favorites" `
	| % { [Environment]::GetFolderPath($_) `
	| % { [IO.Path]::Combine($_, "$entityName.lnk")

function CreateLink ($linkFileName) {
	$ssh = New-Object net.kiertscher.toolbox.filesystem.ShellShortcut $linkFileName
	$ssh.Description = "Desktop access for $entityName"
	$ssh.WorkingDirectory = $entityRoot
	$ssh.Path = "${env:SystemRoot}\explorer.exe"
	$ssh.Arguments = $arguments
	$ssh.IconPath = $icon
	$ssh.IconIndex = "0"
	$ssh.Save()
}

# if at least one of the shortcut exists
$found = $false
foreach ($link in $links) {
	if (Test-Path $link) {
		$found = $true
		break
	}
}
if ($found)
{
	# remove shortcuts and show message box
	$count = 0
	foreach ($link in $links) {
	if (Test-Path $link) {
		Remove-Item $link
		$count++
	}
	}
	if ($count -gt 0) 
	{
		[Windows.Forms.MessageBox]::Show( `
			"Desktop access to the project was removed.", `
			"Desktop Access", "OK", "Information")
	}
}
else
{
	# otherwise create shortcuts
	foreach ($link in $links) {
		CreateLink $link
	}
}

Write-Verbose "--- $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"
