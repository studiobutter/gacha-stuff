Clear-Host
[Console]::Title = "Gacha Clipboard Catcher - Debug Mode"

$systemLanguage = Get-Culture
Write-Host "User TEMP folder: $env:TMP"

# Download language.json from repo to $env:TMP/gacha-log
$gachaLogTmp = Join-Path $env:TMP 'gacha-log'
if (-not (Test-Path $gachaLogTmp)) {
    New-Item -Path $gachaLogTmp -ItemType Directory | Out-Null
}
$languageFile = Join-Path $gachaLogTmp 'language.json'
Invoke-WebRequest -Uri 'https://github.com/studiobutter/gacha-stuff/raw/refs/heads/mutli-lang_2/language.json' -OutFile $languageFile -UseBasicParsing

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
    $commonCode = $regLang.ToLower()
    Write-Host "Loaded saved language from Registry: $regLang"
    # Continue the rest of your script here
    # Download Gacha.Resources.psd1 for the selected language
    $resourceUrl = "https://github.com/studiobutter/gacha-stuff/raw/refs/heads/mutli-lang_2/$commonCode/Gacha.Resources.psd1"
    $resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
    try {
        Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
        Write-Host "Downloaded Gacha.Resources.psd1 for '$commonCode' to $resourceFile" -ForegroundColor Green

        # Import the language resource file
        if (Test-Path $resourceFile) {
            Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale
            Write-Host "Loaded language resource file for '$commonCode'." -ForegroundColor Cyan
        } else {
            Write-Host "Resource file not found after download." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to download Gacha.Resources.psd1 for '$commonCode': $_" -ForegroundColor Red
    }
        if (Test-Path $resourceFile) {
            $GachaResources = Import-PowerShellDataFile -Path $resourceFile
            Write-Output $GachaResources.Greeting
        } else {
            Write-Host "Resource file not found, cannot display greeting." -ForegroundColor Yellow
        }
        return
    }

# Display language menu with system language option
Write-Host "Language:" -ForegroundColor Cyan
for ($i = 0; $i -lt $languages.Count; $i++) {
    $num = $i + 1
    Write-Host ("{0}. {1}" -f $num, $languages[$i].name)
}

# Get user selection, allow Enter for system language
$selectedIndex = -1
$useSystemLang = $false
while ($selectedIndex -lt 1 -or $selectedIndex -gt $languages.Count) {
    $userInput = Read-Host "Default = $($systemLanguage.Name)"
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

if ($commonCode -in @(
    'en-us', 'en-gb', 'en-au', 'en-ca', 'en-nz', 'en-ie', 'en-za', 'en-in', 'en-sg'
)) {
    $commonCode = 'en'
    $env:GACHA_LANG = $commonCode
} elseif ($commonCode -in @('zh-tw', 'zh-hk')) {
    $commonCode = 'zh-tw'
    $env:GACHA_LANG = $commonCode
} elseif ($commonCode -eq 'vi-vn') {
    $commonCode = 'vi'
    $env:GACHA_LANG = $commonCode
} else {
    $env:GACHA_LANG = $commonCode
}

# Download Gacha.Resources.psd1 for the selected language
$resourceUrl = "https://github.com/studiobutter/gacha-stuff/raw/refs/heads/mutli-lang_2/$commonCode/Gacha.Resources.psd1"
$resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
try {
    Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
    Write-Host "Downloaded Gacha.Resources.psd1 for '$commonCode' to $resourceFile" -ForegroundColor Green

    # Import the language resource file
    if (Test-Path $resourceFile) {
        $GachaResources = Import-PowerShellDataFile -Path $resourceFile
        Write-Host "Loaded language resource file for '$commonCode'." -ForegroundColor Cyan
    } else {
        Write-Host "Resource file not found after download." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Failed to download Gacha.Resources.psd1 for '$commonCode': $_" -ForegroundColor Red
}

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

