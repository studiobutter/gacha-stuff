# Check current PowerShell edition

if ($PSVersionTable.PSEdition -eq 'Core') {
    Write-Host "Running in PowerShell Core $($PSVersionTable.PSVersion)"
    return
}

Write-Host "Running in Windows PowerShell $($PSVersionTable.PSVersion)"

# Look for PowerShell Core
$pwsh = Get-Command pwsh.exe -ErrorAction SilentlyContinue

if ($pwsh) {
    Write-Host "PowerShell Core detected. Launching..."

    if ($MyInvocation.MyCommand.Path) {
        & $pwsh.Source -NoProfile -ExecutionPolicy Bypass -File $MyInvocation.MyCommand.Path
    }
    else {
        & $pwsh.Source -NoProfile
    }

    exit $LASTEXITCODE
}
else {
    Write-Host "Current version of PowerShell is older, please download the latest version of PowerShell"
    exit 1
}