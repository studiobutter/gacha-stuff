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
    foreach ($option in $Locale.ToolOptions) {
        Write-Host $option
    }
}

function Get-Cleaner {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal.ps1")))}"
}

function Get-LangReset {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/lang_reset.ps1")))}"
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "cleanup.ps1")))}"
    exit 0
}

while ($true) {
    Show-Menu
    $choice = Read-Host $Locale.EnterChoice
    
    switch ($choice) {
        0 { Close-Clear }
        1 { Get-Cleaner }
        2 { Get-LangReset }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; continue }
    }
    
    Write-Host $Locale.GachaMenuAnyKey -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

Write-Host "Exiting"