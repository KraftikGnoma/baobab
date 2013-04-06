#=============================================================================
# Project: Baobab
# Author: Daniel Kiertscher
# Name: Clean-Project.ps1
# Description: 
#   Removes all files and sub folders from $paths, 
#   except: desktop.ini, .svn, .git.
#   The paths can be relative to the project root.
# Parameter: 
#   - paths:
#       An array with relative paths to folders
#       Default value: @("bin", "tmp")
# Dependencies: 
#   EntityToolsLib.ps1
#=============================================================================
param (
  $paths = @("bin", "tmp")
)

# determine local directory
$entityLocalScripts = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

# load entity library
. "$entityLocalScripts\EntityToolsLib.ps1"

# determine action name
$actionName = Get-ActionName $MyInvocation.MyCommand.Definition

# paths:
#   $entityRoot - root directory of the entity
#   $entityLocalScripts - local script directory in the entity
#   $entityManagement - root directory of the entity management system
#   $entityScripts - script directory of the entity management system
#   $entityActions - directory of the action scripts


####### insert pre action commands here  #######


#######----------------------------#######

& "$entityActions\$actionName.ps1" `
    -entityRoot $entityRoot `
    -paths $paths 

####### insert post action commands here #######


#######----------------------------------#######
