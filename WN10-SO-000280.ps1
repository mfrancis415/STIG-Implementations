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


