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

function Invoke-ScriptFromUrl {
    param([string]$ScriptPath, [string]$ArgsStr = "")
    $url = Get-ScriptUrl $ScriptPath
    $fileName = Split-Path $ScriptPath -Leaf
    $tempFile = Join-Path $env:TMP "gacha-log\$fileName"
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    try {
        if ($url -like 'file:///*') {
            $localPath = $url -replace '^file:///', ''
            $localPath = $localPath -replace '/', '\'
            Copy-Item -Path $localPath -Destination $tempFile -Force
        } else {
            Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
        }
        
        if ([string]::IsNullOrWhiteSpace($ArgsStr)) {
            & $tempFile
        } else {
            $argArray = $ArgsStr -split ' '
            & $tempFile @argArray
        }
    } catch {
        Write-Host "Failed to download or run ${ScriptPath}: $_" -ForegroundColor Red
    }
}

$systemLanguage = Get-Culture
Write-Host "User TEMP folder: $env:TMP"

# Create $env:TMP/gacha-log directory
$gachaLogTmp = Join-Path $env:TMP 'gacha-log'
if (-not (Test-Path $gachaLogTmp)) {
    New-Item -Path $gachaLogTmp -ItemType Directory | Out-Null
}

if ($PSVersionTable.PSEdition -ne 'Core') {
    $pwsh = Get-Command pwsh.exe -ErrorAction SilentlyContinue

    if ($pwsh) {
        Write-Host "PowerShell Core detected. Relaunching..."
        $startFile = Join-Path $gachaLogTmp 'start.ps1'
        $startUrl = Get-ScriptUrl 'start.ps1'
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        if ($startUrl -like 'file:///*') {
            $localPath = $startUrl -replace '^file:///', ''
            $localPath = $localPath -replace '/', '\'
            Copy-Item -Path $localPath -Destination $startFile -Force
        } else {
            Invoke-WebRequest -Uri $startUrl -OutFile $startFile -UseBasicParsing
        }
        
        & $pwsh.Source -NoProfile -ExecutionPolicy Bypass -File $startFile
        exit $LASTEXITCODE
    }
    else {
        Write-Host "[Error: -1] Please install PowerShell (v7.0 or higher) to run this script. Current version: $($PSVersionTable.PSVersion)" -ForegroundColor Red
        exit 1
    }
}

# Download language.json from repo to $env:TMP/gacha-log
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
    $glang = $regLang.ToLower()
    Write-Host "Loaded saved language from Registry: $glang"
    # Continue the rest of your script here
    # Download Gacha.Resources.psd1 for the selected language
    $resourceUrl = Get-ScriptUrl "i18n/$glang/Gacha.Resources.psd1"
    $resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
    try {
        if ($resourceUrl -like 'file:///*') {
            $localResourcePath = $resourceUrl -replace '^file:///', ''
            $localResourcePath = $localResourcePath -replace '/', '\'
            Copy-Item -Path $localResourcePath -Destination $resourceFile -Force
        } else {
            Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
        }
        Write-Host "Downloaded Gacha.Resources.psd1 for '$glang' to $resourceFile" -ForegroundColor Green

        # Import the language resource file
        if (Test-Path $resourceFile) {
            Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale
            Write-Host "Loaded language resource file for '$glang'." -ForegroundColor Cyan
        }
        else {
            Write-Host "Resource file not found after download." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Failed to download Gacha.Resources.psd1 for '$glang': $_" -ForegroundColor Red
    }
    if (Test-Path $resourceFile) {
        $GachaResources = Import-PowerShellDataFile -Path $resourceFile
        Write-Output $GachaResources.Greeting
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        
        $menuUrl = Get-ScriptUrl "menu.ps1"
        $menuFile = Join-Path $gachaLogTmp 'menu.ps1'
        
        try {
            if ($menuUrl -like 'file:///*') {
                $localMenuPath = $menuUrl -replace '^file:///', ''
                $localMenuPath = $localMenuPath -replace '/', '\'
                Copy-Item -Path $localMenuPath -Destination $menuFile -Force
            } else {
                Invoke-WebRequest -Uri $menuUrl -OutFile $menuFile -UseBasicParsing
            }
            
            & $menuFile
        } catch {
            Write-Host "Failed to download or run menu.ps1: $_" -ForegroundColor Red
        }
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
else {
    $env:GACHA_LANG = $commonCode
}

$glang = $commonCode.ToLower()

# Download Gacha.Resources.psd1 for the selected language
$resourceUrl = Get-ScriptUrl "i18n/$glang/Gacha.Resources.psd1"
$resourceFile = Join-Path $gachaLogTmp 'Gacha.Resources.psd1'
try {
    if ($resourceUrl -like 'file:///*') {
        $localResourcePath = $resourceUrl -replace '^file:///', ''
        $localResourcePath = $localResourcePath -replace '/', '\'
        Copy-Item -Path $localResourcePath -Destination $resourceFile -Force
    } else {
        Invoke-WebRequest -Uri $resourceUrl -OutFile $resourceFile -UseBasicParsing
    }
    Write-Host "Downloaded Gacha.Resources.psd1 for '$glang' to $resourceFile" -ForegroundColor Green

    # Import the language resource file
    if (Test-Path $resourceFile) {
        $GachaResources = Import-PowerShellDataFile -Path $resourceFile
        Write-Host "Loaded language resource file for '$glang'." -ForegroundColor Cyan
    }
    else {
        Write-Host "Resource file not found after download." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Failed to download Gacha.Resources.psd1 for '$glang': $_" -ForegroundColor Red
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
    & $saveRegFile $glang
}
catch {
    Write-Host "Failed to download or run saveReg.ps1: $_" -ForegroundColor Red
}