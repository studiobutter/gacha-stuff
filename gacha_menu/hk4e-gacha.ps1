$gachaLogTmp = "$env:TMP\gacha-log"
Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host
function Show-Menu {
    Write-Host $Locale.GachaMenuChooseLink
    foreach ($option in $Locale.RegionOptions) {
        Write-Host $option
    }
}

function Get-Gacha_os {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/getlink.ps1'))} global"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Get-Gacha_cn {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/getlink.ps1'))} china"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
    
}

function Get-Gacha_Cloud {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/main/gacha_clipboard/gacha_cloud_hk4e.ps1'))}"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/mutli-lang_2/cleanup.ps1'))}"
    exit 0
}

while ($true) {
    Show-Menu
    $choice = Read-Host $Locale.RegionChoice
    
    switch ($choice) {
        0 { Close-Clear }
        1 { Get-Gacha_os }
        2 { Get-Gacha_cn }
        3 { Get-Gacha_Cloud }
        default { Write-Host $Locale.GachaMenuInvalidRegion -ForegroundColor Red; }
    }
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
}

