#=============================================================================
# Project: Baobab
# Author: Tobias Kiertscher
# Name: Open-Shell.ps1
# Description: 
#   Shows the shell for the entity
# Dependencies: 
#   EntityToolsLib.ps1
#=============================================================================

# determine local directory
$entityLocalScripts = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Definition)

# load entity library
. "$entityLocalScripts\EntityToolsLib.ps1"

# determine action name
$actionName = Get-ActionName($MyInvocation.MyCommand.Definition)

# paths:
#   $entityRoot - root directory of the entity
#   $entityLocalScripts - local script directory in the entity
#   $entityManagement - root directory of the entity management system
#   $entityScripts - script directory of the entity management system
#   $entityActions - directory of the action scripts


####### insert pre action commands here  #######


#######----------------------------------#######

& "$entityActions\$actionName.ps1" `
    -entityRoot $entityRoot

####### insert post action commands here #######


#######----------------------------------#######
