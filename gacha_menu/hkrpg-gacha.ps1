$gachaLogTmp = "$env:TMP\gacha-log"
Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host
function Show-Menu {
    Write-Host $Locale.GachaMenuChooseLink
    foreach ($option in $Locale.RegionOptionsNoCloud) {
        Write-Host $option
    }
}

function Get-Gacha_os {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/gacha_clipboard/get_warp_link_os.ps1?cachebust=srs")
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Get-Gacha_cn {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12; Invoke-Expression (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/gacha_clipboard/get_warp_link_cn.ps1?cachebust=srs")
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/cleanup.ps1'))}"
    exit 0
}

while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice"
    
    switch ($choice) {
        0 { Close-Clear }
        1 { Get-Gacha_os }
        2 { Get-Gacha_cn }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; }
    }
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}


