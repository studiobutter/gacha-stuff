$GachaLogTmp = Join-Path $env:TMP "gacha-log"
$LocalizationFile = Join-Path $GachaLogTmp "Gacha.Resources.psd1"

Import-LocalizedData -BaseDirectory $GachaLogTmp -FileName "Gacha.Resources.psd1" -BindingVariable Locale -ErrorAction Stop
if (-not (Test-Path $LocalizationFile)) {
    Write-Host "Localization file not found at $LocalizationFile" -ForegroundColor Red
    return
}

# Display greeting from localization file
if ($Locale.Greeting) {
    Write-Host $Locale.Greeting -ForegroundColor Green
} else {
    Write-Host "Greeting not found in localization file." -ForegroundColor Yellow
}