# This is where all the tools will be shown to the user
# This is to correspond to Issue #3

$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host
[Console]::Title = $Locale.GachaMenuTitle

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
    
function Show-Menu {
    Write-Host $Locale.ToolSelection
    foreach ($option in $Locale.CleanerOptions) {
        Write-Host $option
    }
}

function Invoke-NoLauncher {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/no_launcher.ps1")))}"
}

function Invoke-HoYoPlay {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/hyp.ps1")))}"
}


function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "cleanup.ps1")))}"
    exit 0
}

function Show-More {
    param (
        [string]$OptionalParameters
    )
    Write-Host $Locale.ToolCleanerDisclaimer1
    Write-Host $Locale.ToolCleanerDisclaimer2
    Write-Host $Locale.ToolCleanerDisclaimer3
    Write-Host $Locale.ToolCleanerDisclaimer4
    Write-Host $Locale.ToolCleanerDisclaimer5
    Write-Host $Locale.ToolCleanerDisclaimer6
    Write-Host $Locale.ToolCleanerDisclaimer7
    Write-Host $Locale.ToolCleanerDisclaimerLink
    Write-Host $Locale.ToolCleanerAnyKey -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
    Show-Menu
}

while ($true) {
    Show-Menu
    $choice = Read-Host $Locale.EnterChoice
    
    switch ($choice) {
        0 { Close-Clear }
        1 { Invoke-NoLauncher }
        2 { Invoke-HoYoPlay }
        ? { Show-More }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; continue }
    }
    
    Write-Host $Locale.GachaMenuAnyKey -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

Write-Host "Exiting"