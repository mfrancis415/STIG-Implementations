<#
.SYNOPSIS
    This PowerShell script configures the Account Lockout Duration policy to 15 minutes, allowing 0 as a valid alternative (meaning admin unlock required).

.NOTES
    Author          : Monica Francis
    LinkedIn        : linkedin.com/in/mfrancis415/
    GitHub          : github.com/joshmadakor1
    Date Created    : 10-26-2025
    Last Modified   : 10-26-2025
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AC-000005

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

# Desired lockout duration (in minutes)
$desiredDuration = 15

# Get current account lockout duration
$currentDuration = (net accounts | Select-String "Lockout duration").ToString() -replace '[^\d]', ''

if ([int]$currentDuration -ge $desiredDuration -or [int]$currentDuration -eq 0) {
    Write-Host "Account lockout duration is already compliant ($currentDuration minutes)."
} else {
    # Set lockout duration to 15 minutes
    Write-Host "Updating account lockout duration to $desiredDuration minutes..."
    net accounts /lockoutduration:$desiredDuration

    # Verify the change
    $verify = (net accounts | Select-String "Lockout duration").ToString() -replace '[^\d]', ''
    if ([int]$verify -eq $desiredDuration) {
        Write-Host "Lockout duration successfully set to $verify minutes."
    } else {
        Write-Warning "Failed to set lockout duration. Current value: $verify minutes."
    }
}
