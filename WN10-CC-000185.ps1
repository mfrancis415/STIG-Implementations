<#
.SYNOPSIS
    This PowerShell script ensures that AutoRun is disabled system-wide by setting NoAutorun to 1 in the Windows Explorer policies registry key.

.NOTES
    Author          : Monica Francis
    LinkedIn        : linkedin.com/in/mfrancis415/
    GitHub          : github.com/mfrancis415
    Date Created    : 10-26-2025
    Last Modified   : 10-26-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000185

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
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoAutorun"
$valueData = 1  # DWORD 1

# Ensure the registry key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the DWORD value
New-ItemProperty -Path $regPath -Name $valueName -Value $valueData -PropertyType DWord -Force | Out-Null

# Confirm the change
Get-ItemProperty -Path $regPath -Name $valueName
