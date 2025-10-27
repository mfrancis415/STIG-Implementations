<#
.SYNOPSIS
    This PowerShell script ensures the DC (on-battery) power setting policy is enabled by setting DCSettingIndex to 1 in the system power settings registry key.
    
.NOTES
    Author          : Monica Francis
    LinkedIn        : linkedin.com/in/mfrancis415/
    GitHub          : github.com/mfrancis415
    Date Created    : 10-27-2025
    Last Modified   : 10-27-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-SO-000245

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : 
    PowerShell Ver. : 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
#>

# Define the registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51"
$valueName = "DCSettingIndex"
$valueData = 1  # DWORD value

# Ensure the key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $regPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null

# Verify the change
Get-ItemProperty -Path $regPath -Name $valueName
