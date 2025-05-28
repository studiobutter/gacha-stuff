Clear-Host
[Console]::Title = "Gacha Clipboard Catcher - Debug Mode"

$systemLanguage = Get-Culture
Write-Host "System Language: $($systemLanguage.Name)"

# Load language data from language.json
$languageData = Get-Content -Raw -Path ".\language.json" | ConvertFrom-Json

# Display language options
Write-Host "Available Languages:"
for ($i = 0; $i -lt $languageData.languages.Count; $i++) {
    Write-Host "$($i + 1). $($languageData.languages[$i].name)"
}

# Prompt user for language selection
$selection = Read-Host "Select a language (press Enter to use system language: $($systemLanguage.Name))"

if ([string]::IsNullOrWhiteSpace($selection)) {
    # Use system language
    $selectedLanguage = $languageData.languages | Where-Object {
        $_.codes -contains $systemLanguage.Name.ToLower()
    }
    if (-not $selectedLanguage) {
        # Try matching by language prefix (e.g., "en" for "en-US")
        $langPrefix = $systemLanguage.Name.Split('-')[0].ToLower()
        $selectedLanguage = $languageData.languages | Where-Object {
            $_.codes -contains $langPrefix
        }
    }
    if ($selectedLanguage) {
        Write-Host "Selected language: $($selectedLanguage.name)"
    } else {
        Write-Host "System language not found in language.json. Defaulting to English."
        $selectedLanguage = $languageData.languages | Where-Object { $_.name -eq "English" }
    }
} else {
    # Use user selection
    $index = [int]$selection - 1
    if ($index -ge 0 -and $index -lt $languageData.languages.Count) {
        $selectedLanguage = $languageData.languages[$index]
        Write-Host "Selected language: $($selectedLanguage.name)"
    } else {
        Write-Host "Invalid selection. Defaulting to English."
        $selectedLanguage = $languageData.languages | Where-Object { $_.name -eq "English" }
    }
}

# Set the selected language in the environment variable
$env:LANGUAGE = $selectedLanguage.name

# Ask user if they want to remember their choice
$rememberChoice = Read-Host "Do you want to remember this language selection for next time? (y/n). Administrator privileges required to save this preference"
if ([string]::IsNullOrWhiteSpace($rememberChoice)) {
    $rememberChoice = "n"  # Default to not remembering if input is empty
}
if ($rememberChoice -match '^(y|yes)$') {
    # Check if running as administrator
    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Host "Restarting script as Administrator to save your preference..."

        # Check for pwsh.exe (PowerShell Core)
        $pwshPath = (Get-Command pwsh.exe -ErrorAction SilentlyContinue)?.Source
        if ($pwshPath) {
            Start-Process $pwshPath "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        } else {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        }
        exit
    }

    # Save the selected language code to registry
    $regPath = "HKCU:\Software\gacha-log"
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "lang" -Value $selectedLanguage.name
    Write-Host "Language preference saved to registry."
}
