# Prompt user to confirm language reset
$answer = Read-Host "Do you want to reset the language preference? (y/n) (Script will close if yes)"

if ($answer -eq 'y') {
    # Remove 'lang' value from registry
    Remove-ItemProperty -Path 'HKCU:\Software\gacha-log' -Name 'lang' -ErrorAction SilentlyContinue
    Write-Host "Language preference reseted. Script will now close."
    # Run cleanup.ps1
    & "$PSScriptRoot\..\cleanup.ps1"
    exit
} elseif ($answer -eq 'n') {
    Write-Host "No changes made."
} else {
    Write-Host "Invalid input. No changes made."
}
