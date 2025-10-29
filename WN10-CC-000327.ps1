<#
.SYNOPSIS
    This PowerShell script that enables PowerShell Transcription on Windonws 10.

.NOTES
    Author          : Monica Francis
    LinkedIn        : linkedin.com/in/mfrancis415/
    GitHub          : github.com/mfrancis415
    Date Created    : 10-28-2025
    Last Modified   : 10-28-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000327

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

<#
.SYNOPSIS
This PowerShell script ensures that PowerShell transcription logging is enabled by confirming that EnableTranscripting = 1 in the registry.
#>

Write-Host "=== Remediating PowerShell Transcription Policy ===`n"

$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"

# Ensure the registry path exists
If (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
    Write-Host "Created registry path: $RegPath"
}

# Set required value
Set-ItemProperty -Path $RegPath -Name "EnableTranscripting" -Value 1 -Type DWord
Write-Host "Set EnableTranscripting to 1"

# Apply group policy update
gpupdate /force | Out-Null

Write-Host "`n=== Remediation Complete ==="
