$gachaLogTmp = "$env:TMP\gacha_log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host
[Console]::Title = $Locale.GachaMenuTitle
function Show-Menu {
    Write-Host $Locale.GachaMenuDescription
    foreach ($option in $Locale.GachaMenuOptions) {
        Write-Host $option
    }
}

function Get-Gacha_hk4e {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/gacha_menu/hk4e-gacha.ps1'))}"
}

function Get-Gacha_hkrpg {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/gacha_menu/hkrpg-gacha.ps1'))}"
}

function Get-Gacha_nap {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/gacha_menu/nap-gacha.ps1'))}"
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/cleanup.ps1'))}"
    exit 0
}

while ($true) {
    Show-Menu
    $choice = Read-Host $Locale.EnterChoice
    
    switch ($choice) {
        0 { Close-Clear }
        1 { Get-Gacha_hk4e }
        2 { Get-Gacha_hkrpg }
        3 { Get-Gacha_nap }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; continue }
    }
    
    Write-Host $Locale.GachaMenuAnyKey -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

Write-Host "Exiting"