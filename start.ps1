Clear-Host
[Console]::Title = "Gacha Clipboard Catcher - Debug Mode"

$systemLanguage = Get-Culture
Write-Host "System Language: $($systemLanguage.Name)"

Write-Host "User TEMP folder: $env:TMP"

# Load available languages from language.json
$languageFile = Join-Path $PSScriptRoot 'language.json'
$languagesJson = Get-Content $languageFile -Raw | ConvertFrom-Json
$languages = $languagesJson.languages

# Check Registry for saved language
$regPath = 'HKCU:\Software\gacha-log'
$regLang = $null
if (Test-Path $regPath) {
    try {
        $regLang = (Get-ItemProperty -Path $regPath -Name 'lang' -ErrorAction SilentlyContinue).lang
    } catch {}
}

if ($regLang) {
    $env:GACHA_LANG = $regLang
    Write-Host "Loaded saved language from Registry: $regLang"
    # Continue the rest of your script here
    return
}

# Display language menu with system language option
Write-Host "Select your language (or press Enter to use System Language: $($systemLanguage.Name)):" -ForegroundColor Cyan
for ($i = 0; $i -lt $languages.Count; $i++) {
    $num = $i + 1
    Write-Host ("{0}. {1}" -f $num, $languages[$i].name)
}

# Get user selection, allow Enter for system language
$selectedIndex = -1
$useSystemLang = $false
while ($selectedIndex -lt 1 -or $selectedIndex -gt $languages.Count) {
    $userInput = Read-Host "Enter the number of your language choice (or press Enter for System Language)"
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        $useSystemLang = $true
        break
    }
    if ($userInput -match '^[0-9]+$') {
        $selectedIndex = [int]$userInput
    }
    if ($selectedIndex -lt 1 -or $selectedIndex -gt $languages.Count) {
        Write-Host "Invalid selection. Please try again." -ForegroundColor Yellow
    }
}

if ($useSystemLang) {
    $commonCode = $systemLanguage.Name.ToLower()
    Write-Host "Using System Language: $($systemLanguage.Name) ($commonCode)"
} else {
    $selectedLanguage = $languages[$selectedIndex - 1]
    $commonCode = $selectedLanguage.commonCode
    Write-Host "Selected language: $($selectedLanguage.name) ($commonCode)"
}

# Set environment variable for this session
$env:GACHA_LANG = $commonCode

# Ask if user wants to save in Registry
$saveReg = Read-Host "Do you want to save this language in the Registry for next time? (y/n)"
if ($saveReg -match '^(y|Y)') {
    try {
        $regPath = 'HKCU:\\Software\\gacha-log'
        if (-not (Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        Set-ItemProperty -Path $regPath -Name 'lang' -Value $commonCode
        Write-Host "Language saved in Registry under HKCU/Software/gacha-log/lang." -ForegroundColor Green
    } catch {
        Write-Host "Failed to save language in Registry: $_" -ForegroundColor Red
    }
}

