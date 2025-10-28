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

Write-Host "=== Checking PowerShell Transcription Policy ===`n"

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
$valueName = "EnableTranscripting"
$requiredValue = 1

if (Test-Path $regPath) {
    $regValue = Get-ItemProperty -Path $regPath -ErrorAction SilentlyContinue

    if ($regValue.$valueName -eq $requiredValue) {
        Write-Host "Compliant: Transcription is enabled. EnableTranscripting = 1" -ForegroundColor Green
    } else {
        Write-Host "FINDING: EnableTranscripting is not set to 1" -ForegroundColor Red
    }
} else {
    Write-Host "FINDING: Registry path for transcription does not exist" -ForegroundColor Red
}

Write-Host "`n=== Compliance Check Completed ==="
