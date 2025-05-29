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
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_menu/hk4e-gacha.ps1'))}"
}

function Get-Gacha_hkrpg {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_menu/hkrpg-gacha.ps1'))}"
}

function Get-Gacha_nap {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_menu/nap-gacha.ps1'))}"
}

try {
    while ($true) {
        Show-Menu
        $choice = Read-Host $Locale.GachaMenuChoice
        
        switch ($choice) {
            1 { Get-Gacha_hk4e }
            2 { Get-Gacha_hkrpg }
            3 { Get-Gacha_nap }
            default { Write-Host $Locale.GachaMenuInvalidChoice -ForegroundColor Red; continue }
        }
        
        Write-Host $Locale.GachaMenuAnyKey -ForegroundColor Yellow
        # Wait for any key press
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        Clear-Host
    }
}
catch [System.Management.Automation.Host.ControlCException] {
    # Handle Ctrl+C: delete $gachaLogTmp
    if (Test-Path $gachaLogTmp) {
        Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        Remove-Item -Path $gachaLogTmp -Recurse -Force -ErrorAction SilentlyContinue
    }
    exit
}

Write-Host "Exiting"
