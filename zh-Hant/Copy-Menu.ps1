Clear-Host
[Console]::Title = "Gacha Clipboard Catcher"
function Show-Menu {
    Write-Host "Select which Gacha link to obtain:"
    Write-Host "1. Genshin"
    Write-Host "2. Star Rail"
    Write-Host "3. Zenless"
    Write-Host "Press Ctrl + C to exit"
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


while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        1 { Get-Gacha_hk4e }
        2 { Get-Gacha_hkrpg }
        3 { Get-Gacha_nap }
        default { Write-Host "Invalid choice. Please try again." }
    }
    
    Write-Host "Press any key to return to the menu..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

Write-Host "Exiting"
