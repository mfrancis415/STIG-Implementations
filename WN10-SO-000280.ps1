<#
.SYNOPSIS
   This PowerShell script ensures local Administrator accounts comply with password age requirements and verifies that LAPS is properly configured and operational.

.NOTES
    Author          : Monica Francis
    LinkedIn        : linkedin.com/in/mfrancis415/
    GitHub          : github.com/mfrancis415
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
    1. If any local Administrator account is enabled.
    2. If the local Administrator password was last set within 60 days.
    3. If LAPS is enabled and configured properly.
    4. If LAPS operational logs show successful policy processing. 
#>

<#
.SYNOPSIS
Checks:
1. If any local Administrator account is enabled.
2. If the local Administrator password was last set within 60 days.
3. If LAPS is enabled and configured properly.
4. If LAPS operational logs show successful policy processing.

This script assumes Windows 10 and native PowerShell.
#>

Write-Host "=== Local Administrator Account and LAPS Compliance Check ===`n"

# --- Step 1: Check for enabled local administrators ---
$admins = Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -match "Administrator" }
if (-not $admins) {
    Write-Host "No enabled local Administrator accounts found. Not Applicable.`n"
    return
}

# --- Step 2: Check PasswordLastSet date for enabled Administrator accounts ---
foreach ($user in $admins) {
    if ($null -eq $user.PasswordLastSet) {
        Write-Host "FINDING: Administrator account $($user.Name) has never had its password set.`n" -ForegroundColor Red
        continue
    }

    $daysSinceLastSet = (New-TimeSpan -Start $user.PasswordLastSet -End (Get-Date)).Days
    Write-Host "Account: $($user.Name)"
    Write-Host "Password last set: $($user.PasswordLastSet)"
    Write-Host "Days since last password change: $daysSinceLastSet"

    if ($daysSinceLastSet -gt 60) {
        Write-Host "FINDING: Password older than 60 days.`n" -ForegroundColor Red
    } else {
        Write-Host "Compliant: Password age within 60 days.`n" -ForegroundColor Green
    }
}

# --- Step 3: Verify LAPS Configuration ---
$lapsRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LAPS"
if (Test-Path $lapsRegPath) {
    $lapsSettings = Get-ItemProperty -Path $lapsRegPath
    Write-Host "`n=== LAPS Policy Settings ==="

    $enabled = $lapsSettings."EnableLocalAdminPasswordManagement"
    $complexity = $lapsSettings."PasswordComplexity"
    $length = $lapsSettings."PasswordLength"
    $age = $lapsSettings."PasswordAgeDays"

    Write-Host "EnableLocalAdminPasswordManagement: $enabled"
    Write-Host "PasswordComplexity: $complexity"
    Write-Host "PasswordLength: $length"
    Write-Host "PasswordAgeDays: $age"

    $compliance = $true

    if ($enabled -ne 1) {
        Write-Host "FINDING: LAPS not enabled." -ForegroundColor Red
        $compliance = $false
    }

    if ($complexity -ne 4) {
        Write-Host "FINDING: Password complexity not set to 4 (uppercase, lowercase, numbers, special chars)." -ForegroundColor Red
        $compliance = $false
    }

    if ($length -lt 14) {
        Write-Host "FINDING: Password length less than 14." -ForegroundColor Red
        $compliance = $false
    }

    if ($age -ne 60) {
        Write-Host "FINDING: Password age not set to 60 days." -ForegroundColor Red
        $compliance = $false
    }

    if ($compliance) {
        Write-Host "LAPS configuration is compliant.`n" -ForegroundColor Green
    }
} else {
    Write-Host "`nFINDING: LAPS policy not found in registry path $lapsRegPath" -ForegroundColor Red
}

# --- Step 4: Check LAPS Operational Logs ---
Write-Host "`n=== Checking LAPS Operational Logs ==="
$lapsLogName = "Microsoft-Windows-LAPS/Operational"

if (-not (Get-WinEvent -ListLog $lapsLogName -ErrorAction SilentlyContinue)) {
    Write-Host "FINDING: LAPS operational log not found. LAPS may not be installed or logging is disabled." -ForegroundColor Red
} else {
    $lapsLog = Get-WinEvent -LogName $lapsLogName -ErrorAction SilentlyContinue -MaxEvents 20
    if ($null -eq $lapsLog) {
        Write-Host "FINDING: No events found in the LAPS operational log." -ForegroundColor Red
    } else {
        $successEvents = $lapsLog | Where-Object { $_.Message -match "policy processing completed successfully" }
        if ($successEvents) {
            Write-Host "LAPS policy processing completed successfully (recent log found)." -ForegroundColor Green
        } else {
            Write-Host "FINDING: LAPS policy process not completing successfully." -ForegroundColor Red
        }
    }
}

Write-Host "`n=== Compliance Check Completed ==="


