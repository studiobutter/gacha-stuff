Clear-Host
function Show-Menu {
    Write-Host "Make sure to open the Gacha Page before choosing any of these options"
    Write-Host "Select which Gacha link to obtain:"
    Write-Host "1. Global"
    Write-Host "2. China"
    Write-Host "3. Cloud"
    Write-Host "Press Ctrl + C to exit"
}

function Get-Gacha_os {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/get_signal_link_os.ps1")
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

function Get-Gacha_cn {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/get_signal_link_cn.ps1")
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

function Get-Gacha_Cloud {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/gacha_cloud_nap.ps1")
    Write-Host "Press any key to return to the menu, or Ctrl + C to exit"
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        1 { Get-Gacha_os }
        2 { Get-Gacha_cn }
        default { Write-Host "Invalid choice. Please try again." }
    }
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

