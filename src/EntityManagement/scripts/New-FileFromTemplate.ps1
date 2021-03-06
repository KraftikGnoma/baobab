#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: New-FileFromTemplate.ps1
# Description: 
#   Creates a file from a template
# Parameter: 
#   - targetDir: 
#       The target directory for the file
#   - fileDescriptor:
#       The XML element from the XML template, describing the file
#   - aspectNames:
#       An array with the requested aspect set
#   - processProperties:
#       A hash table with additional informations for the creation process
# Dependencies: 
# 
# Remarks: 
#   All file templates are stored in the folder '<EntitManagement>\templates'.
#   A file template can be passive, meaning it just need tobe copied.
#   Or the file template can be active, meaning the template is represented
#   by a script which, given the target path, creates the file.
#   Passive templates do have the file name extension '.template'. 
#   Aktive tempaltes do have the file name extension '.template.ps1'
#=============================================================================

param(
    [string]$targetDir,
    [System.Xml.XmlElement]$fileDescriptor,
	$aspectNames,
    [System.Collections.Hashtable]$processProperties = @{}
)

Write-Verbose "+++ New-FileFromTemplate.ps1"

$scriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

if (-not $(Test-Path $targetDir))
{
    throw "Could not find the target directory:`n`t$targetDir"
}

$targetName = & "$scriptRoot\Expand-String.ps1" `
	-text $fileDescriptor.name `
	-variables $processProperties

$templateName = $fileDescriptor.template
$targetPath = "$targetDir\$targetName"

if (-not $(Test-Path $targetPath) `
	-or $fileDescriptor.allowOverride)
{
	$templatePath = "$scriptRoot\..\templates\$templateName.template"
	
	if (Test-Path "$templatePath.ps1")
	{
		$content = & "$templatePath.ps1" `
			-targetPath $targetPath `
			-aspectNames $aspectNames `
			-processProperties $processProperties
	
		#Set-Content $targetPath $content
	}
	elseif (Test-Path $templatePath)
	{
		Copy-Item $templatePath $targetPath
	}
	else
	{
		throw "Could not find the file template:`n`tName: $tamplateName`n`tPath: $templatePath"
	}
	
	if (-not $(Test-Path $targetPath))
	{
		throw "Target file was not created:`n`t$targetPath"
	}
}

$file = New-Object System.IO.FileInfo $targetPath
$a = $file.Attributes

if ($fileDescriptor.hidden)
{
	$a = $a -bor [System.IO.FileAttributes]::Hidden
}

if ($fileDescriptor.system)
{
	$a = $a -bor [System.IO.FileAttributes]::System
}

if ($fileDescriptor.readonly)
{
	$a = $a -bor [System.IO.FileAttributes]::ReadOnly
}

$file.Attributes = $a

Write-Verbose "--- New-FileFromTemplate.ps1"
