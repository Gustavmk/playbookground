<#
.SYNOPSIS
  Script to find the GUID of an application
.DESCRIPTION
  This script will find the GUID of an application by searching the uninstall keys in the registry for the Application Name and write it to the output.
  If the application isn't found, the script will throw an error.
.PARAMETER ApplicationName
  Specifies the name to search the registry for
.NOTES
  Version:        0.1
  Author:         Sven de Windt
  Creation Date:  2020 02 03
  Purpose/Change: Initial script development
.EXAMPLE
  Get-SoftwareGuid -ApplicationName "Microsoft Monitoring Agent"
#>

#requires -version 3.0

#-----------------------------------------------------------[Parameters]-----------------------------------------------------------

param(
    [CmdletBinding()]
        [parameter(mandatory = $false)][String]$ApplicationName = "Microsoft Monitoring Agent"
)
#---------------------------------------------------------[Initialisations]--------------------------------------------------------

Set-StrictMode -Version Latest

# Set Error Action to Silently Continue
$ErrorActionPreference = "Stop"

#----------------------------------------------------------[Declarations]----------------------------------------------------------

$x86Path = "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
$x64Path = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"

#-----------------------------------------------------------[Execution]------------------------------------------------------------

$installedItemsX86 = Get-ItemProperty -Path $x86Path | Select-Object -Property DisplayName, PSChildName
$installedItemsX64 = Get-ItemProperty -Path $x64Path | Select-Object -Property DisplayName, PSChildName
$installedItems = $installedItemsX86 + $installedItemsX64
$App = $installedItems | where {$_.displayname -like $ApplicationName}

if ($App -eq $null){
    throw "No application found with the name $($ApplicationName)"
}

$Output = New-Object -TypeName psobject @{
    DisplayName = $App[0].DisplayName
    guid = $App[0].PSChildName
}

Write-Output $Output | ConvertTo-Json

#msiexec /x {786970C5-E6F6-4A41-B238-AE25D4B91EEA} /qn


