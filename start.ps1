Clear-Host
[Console]::Title = "Gacha Clipboard Catcher"

function Get-ScriptUrl {
    param([string]$ScriptPath)
    
    $isLocalTesting = $env:GACHA_LOCAL_TEST -eq "true"
    if ($isLocalTesting) {
        $localPath = Join-Path $env:GACHA_LOCAL_PATH $ScriptPath
        return "file:///$($localPath.Replace('\', '/'))"
    }
    else {
        return "https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/$ScriptPath"
    }
}

$systemLanguage = Get-Culture
Write-Host "User TEMP folder: $env:TMP"

# Download language.json from repo to $env:TMP/gacha-log
$gachaLogTmp = Join-Path $env:TMP 'gacha-log'
if (-not (Test-Path $gachaLogTmp)) {
    New-Item -Path $gachaLogTmp -ItemType Directory | Out-Null
}
$languageFile = Join-Path $gachaLogTmp 'language.json'
$languageJsonUrl = Get-ScriptUrl 'language.json'
if ($languageJsonUrl -like 'file:///*') {
    $localPath = $languageJsonUrl -replace '^file:///', ''
    $localPath = $localPath -replace '/', '\'
    Copy-Item -Path $localPath -Destination $languageFile -Force
} else {
    Invoke-WebRequest -Uri $languageJsonUrl -OutFile $languageFile -UseBasicParsing
}

$languagesJson = Get-Content $languageFile -Raw | ConvertFrom-Json
$languages = $languagesJson.languages

# Check Registry for saved language
$regPath = 'HKCU:\Software\gacha-log'
$regLang = $null
if (Test-Path $regPath) {
    try {
        $regLang = (Get-ItemProperty -Path $regPath -Name 'lang' -ErrorAction SilentlyContinue).lang
    }
    catch {}
}

if ($regLang) {
    $env:GACHA_LANG = $regLang
    $commonCode = $regLang.ToLower()
    Write-Host "Loaded saved language from Registry: $regLang"
    # Continue the rest of your script here
    # Download Gacha.Resources.psd1 for the selected language
    $resourceUrl = Get-ScriptUrl "i18n/$commonCode/Gacha.Resources.psd1"
    $resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
    try {
        if ($resourceUrl -like 'file:///*') {
            $localResourcePath = $resourceUrl -replace '^file:///', ''
            $localResourcePath = $localResourcePath -replace '/', '\'
            Copy-Item -Path $localResourcePath -Destination $resourceFile -Force
        } else {
            Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
        }
        Write-Host "Downloaded Gacha.Resources.psd1 for '$commonCode' to $resourceFile" -ForegroundColor Green

        # Import the language resource file
        if (Test-Path $resourceFile) {
            Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale
            Write-Host "Loaded language resource file for '$commonCode'." -ForegroundColor Cyan
        }
        else {
            Write-Host "Resource file not found after download." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Failed to download Gacha.Resources.psd1 for '$commonCode': $_" -ForegroundColor Red
    }
    if (Test-Path $resourceFile) {
        $GachaResources = Import-PowerShellDataFile -Path $resourceFile
        Write-Output $GachaResources.Greeting
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        $menuScript = (New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "menu.ps1"))
        Invoke-Expression $menuScript
    }
    else {
        Write-Host "Resource file not found, cannot display greeting." -ForegroundColor Yellow
    }
    return
}
# Download language.json from repo to $env:TMP/gacha-log
$gachaLogTmp = Join-Path $env:TMP 'gacha-log'
if (-not (Test-Path $gachaLogTmp)) {
    New-Item -Path $gachaLogTmp -ItemType Directory | Out-Null
}
$languageFile = Join-Path $gachaLogTmp 'language.json'
$languageJsonUrl = Get-ScriptUrl 'language.json'
if ($languageJsonUrl -like 'file:///*') {
    $localPath = $languageJsonUrl -replace '^file:///', ''
    $localPath = $localPath -replace '/', '\'
    Copy-Item -Path $localPath -Destination $languageFile -Force
} else {
    Invoke-WebRequest -Uri $languageJsonUrl -OutFile $languageFile -UseBasicParsing
}

$languagesJson = Get-Content $languageFile -Raw | ConvertFrom-Json
$languages = $languagesJson.languages

# Determine if system language is available in language.json, fallback to English if not
$systemLangCode = $systemLanguage.Name.ToLower()
$availableCodes = @()
foreach ($lang in $languages) {
    $availableCodes += $lang.codes
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
    $userInput = Read-Host "Default = $($systemLanguage.Name) [Enter]"
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
    $foundLang = $null
    foreach ($lang in $languages) {
        if ($lang.codes -contains $systemLangCode) {
            $foundLang = $lang
            break
        }
    }
    if ($foundLang) {
        $commonCode = $foundLang.commonCode
        Write-Host "Using System Language: $($systemLanguage.Name) ($commonCode)"
    }
    else {
        # Fallback to English
        $englishLang = $languages | Where-Object { $_.commonCode -eq 'en' }
        if ($englishLang) {
            $commonCode = $englishLang.commonCode
            Write-Host "System Language '$($systemLanguage.Name)' not available, falling back to English ($commonCode)" -ForegroundColor Yellow
        }
        else {
            Write-Host "System Language and English fallback not found in language.json!" -ForegroundColor Red
            exit 1
        }
    }
}
else {
    $selectedLanguage = $languages[$selectedIndex - 1]
    $commonCode = $selectedLanguage.commonCode
    Write-Host "Selected language: $($selectedLanguage.name) ($commonCode)"
}

if ($commonCode -in @(
        'en-us', 'en-gb', 'en-au', 'en-ca', 'en-nz', 'en-ie', 'en-za', 'en-in', 'en-sg'
    )) {
    $commonCode = 'en'
    $env:GACHA_LANG = $commonCode
}
elseif ($commonCode -in @('zh-tw', 'zh-hk')) {
    $commonCode = 'zh-tw'
    $env:GACHA_LANG = $commonCode
}
elseif ($commonCode -eq 'vi-vn') {
    $commonCode = 'vi'
    $env:GACHA_LANG = $commonCode
}
else {
    $env:GACHA_LANG = $commonCode
}

# Download Gacha.Resources.psd1 for the selected language
$resourceUrl = Get-ScriptUrl "i18n/$commonCode/Gacha.Resources.psd1"
$resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
try {
    if ($resourceUrl -like 'file:///*') {
        $localResourcePath = $resourceUrl -replace '^file:///', ''
        $localResourcePath = $localResourcePath -replace '/', '\'
        Copy-Item -Path $localResourcePath -Destination $resourceFile -Force
    } else {
        Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
    }
    Write-Host "Downloaded Gacha.Resources.psd1 for '$commonCode' to $resourceFile" -ForegroundColor Green

    # Import the language resource file
    if (Test-Path $resourceFile) {
        $GachaResources = Import-PowerShellDataFile -Path $resourceFile
        Write-Host "Loaded language resource file for '$commonCode'." -ForegroundColor Cyan
    }
    else {
        Write-Host "Resource file not found after download." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Failed to download Gacha.Resources.psd1 for '$commonCode': $_" -ForegroundColor Red
}

# Download saveReg.ps1 and execute it with $commonCode as argument
$saveRegUrl = Get-ScriptUrl 'saveReg.ps1'
$saveRegFile = Join-Path $gachaLogTmp 'saveReg.ps1'
try {
    if ($saveRegUrl -like 'file:///*') {
        $localSaveRegPath = $saveRegUrl -replace '^file:///', ''
        $localSaveRegPath = $localSaveRegPath -replace '/', '\\'
        Copy-Item -Path $localSaveRegPath -Destination $saveRegFile -Force
        Write-Host "Copied saveReg.ps1 to $saveRegFile" -ForegroundColor Green
    } else {
        Invoke-WebRequest -Uri $saveRegUrl -OutFile $saveRegFile -UseBasicParsing
        Write-Host "Downloaded saveReg.ps1 to $saveRegFile" -ForegroundColor Green
    }
    & $saveRegFile $commonCode
}
catch {
    Write-Host "Failed to download or run saveReg.ps1: $_" -ForegroundColor Red
}