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
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gacha.studiobutter.io.vn/gacha_clipboard/getlink.ps1?ref_type=heads'))} global"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Get-Gacha_cn {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gacha.studiobutter.io.vn/gacha_clipboard/getlink.ps1?ref_type=heads'))} china"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
    
}

function Get-Gacha_Cloud {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gacha.studiobutter.io.vn/gacha_clipboard/gacha_cloud_hk4e.ps1?ref_type=heads'))}"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gacha.studiobutter.io.vn/cleanup.ps1?ref_type=heads'))}"
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

