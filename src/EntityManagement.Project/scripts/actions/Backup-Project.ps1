#=============================================================================
# Project: Baobab
# Author: Daniel Kiertscher
# Name: Backup-Project.ps1
# Description: 
#   Creates a compressed backup of the project and stores it, annotated
#   with a timestamp, in the specified directory.
# Parameter: 
#   - entityRoot: 
#       Path to the root of the entity
#       Default value: Current working directory
#   - targetDir:
#       Target directory to store the archive
#       Default value: <project root>\backup
#   - versionIgnore:
#       $true, if folder named '.svn' or '.git' shell be excluded;
#       otherwise $false
#       Default value: $false
#   - zipFormat:
#       $true, if the archive shall be in ZIP format, $false for 
#       self-extracting SFX format
#       Default value: $true
# Dependencies:
#   Tool 7zip
#=============================================================================

param (
	[string]$entityRoot = $(Get-Location),
	[string]$targetDir = [IO.Path]::Combine($entityRoot, "backup"),
	[switch]$versionIgnore = $false,
	[switch]$zipFormat = $true
)

Write-Verbose "+++ $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"

$entityActions = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)
$entityManagement = "$entityActions\..\.."
$entityScripts = [IO.Path]::Combine($entityManagement,"scripts")
$entityName = [IO.Path]::GetFileName($entityRoot)

# check and format entityRoot
if (-not $(Test-Path $entityRoot))
{
    throw "Could not find the target directory for the entity:`n`t$entityRoot"
}

$entityRoot = Resolve-Path $entityRoot

# check target path for archive
if (-not $(Test-Path $targetDir))
{
    mkDir $targetDir
}

# format date and time string
$timeStamp = [DateTime]::Now.ToString("yyyy-MM-dd HHmmss")

# get path to 7zip
$7Zip = & "$entityScripts\Get-Tool.ps1" "7zip"

# build file extension and archiver arguments from the configuration
if ($versionIgnore)
{
	$paramIgnore = "`"-x!.svn`" `"-x!.git`" `"-x!backup`""
}
else
{
	$paramIgnore = "-x!backup"
}
if ($zipFormat)
{
	$fileType = ".zip"
	$paramType = "-tzip"
}
else
{
	$fileType = ".exe"
	$paramType = "-sfx7z.sfx"
}

# build target path
$targetPath = "$targetDir\$entityName $timeStamp$fileType"

# Determine number of processor cores and decide over load balance
$threads = [Math]::Max([Environment]::ProcessorCount / 2, 1)

# call 7-Zip with arguments
& $7Zip "a" $paramType $targetPath $entityRoot $paramIgnore "-r" "–ssw" "-mx=5" "-mmt=$threads"

Write-Verbose "--- $([IO.Path]::GetFileName($MyInvocation.MyCommand.Definition)) (action)"
