$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host

# Print disclaimer with line breaks, handle lists
Write-Host $Locale.ToolCleanerDisclaimer1
Write-Host $Locale.BlankLine
Write-Host $Locale.ToolCleanerDisclaimer2
foreach ($line in $Locale.ToolCleanerDisclaimer3) {
    Write-Host $line
}

Write-Host $Locale.BlankLine
Write-Host $Locale.ToolCleanerDisclaimer4
Write-Host $Locale.BlankLine
Write-Host $Locale.ToolCleanerDisclaimer5
Write-Host $Locale.ToolCleanerDisclaimerLink
Write-Host $Locale.BlankLine
Write-Host $Locale.ToolCleanerAnyKey -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# Clear the console
Clear-Host

# Check for the following directories if they exist:
$directoriesToCheck = @(
    "$env:USERPROFILE\AppData\LocalLow\miHoYo\Genshin Impact\",
    "$env:USERPROFILE\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\",
    "$env:USERPROFILE\AppData\LocalLow\Cognosphere\Star Rail\",
    "$env:USERPROFILE\AppData\LocalLow\miHoYo\$([char]0x5d29)$([char]0x574f)$([char]0xff1a)$([char]0x661f)$([char]0x7a79)$([char]0x94c1)$([char]0x9053)\",
    "$env:USERPROFILE\AppData\LocalLow\miHoYo\ZenlessZoneZero\",
    "$env:USERPROFILE\AppData\LocalLow\miHoYo\$([char]0x7edd)$([char]0x533a)$([char]0x96f6)\"
)

foreach ($dir in $directoriesToCheck) {
    if (Test-Path -Path $dir) {
        Write-Host "Found directory: $dir" -ForegroundColor Green
    } else {
        Write-Host "Directory not found: $dir" -ForegroundColor Red
    }
}