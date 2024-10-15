Clear-Host
function Show-Menu {
    Write-Host "Select which Gacha link to obtain:"
    Write-Host "1. Global"
    Write-Host "2. China"
    Write-Host "3. Cloud"
    Write-Host "Press Ctrl + C to exit"
}

function Get-Gacha_os {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/getlink.ps1'))} global"
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

function Get-Gacha_cn {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/getlink.ps1'))} china"
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

function Get-Gacha_Cloud {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/gacha_cloud.ps1'))}"
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        1 { Get-Gacha_os }
        2 { Get-Gacha_cn }
        3 { Get-Gacha_Cloud }
        default { Write-Host "Invalid choice. Please try again." }
    }
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

