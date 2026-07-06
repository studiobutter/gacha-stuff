$gachaLogTmp = "$env:TMP\gacha-log"
Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host

function Get-ScriptUrl {
    param([string]$ScriptPath)
    
    $isLocalTesting = $env:GACHA_LOCAL_TEST -eq "true"
    if ($isLocalTesting) {
        $localPath = Join-Path $env:GACHA_LOCAL_PATH $ScriptPath
        return "file:///$($localPath.Replace('\', '/'))"
    }
    else {
        return "https://gacha.studiobutter.io.vn/$ScriptPath"
    }
}

function Invoke-ScriptFromUrl {
    param([string]$ScriptPath, [string]$ArgsStr = "")
    $url = Get-ScriptUrl $ScriptPath
    $fileName = Split-Path $ScriptPath -Leaf
    $tempFile = Join-Path $env:TMP "gacha-log\$fileName"
    
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    try {
        if ($url -like 'file:///*') {
            $localPath = $url -replace '^file:///', ''
            $localPath = $localPath -replace '/', '\'
            Copy-Item -Path $localPath -Destination $tempFile -Force
        } else {
            Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing
        }
        
        if ([string]::IsNullOrWhiteSpace($ArgsStr)) {
            & $tempFile
        } else {
            $argArray = $ArgsStr -split ' '
            & $tempFile @argArray
        }
    } catch {
        Write-Host "Failed to download or run ${ScriptPath}: $_" -ForegroundColor Red
    }
}

function Show-Menu {
    Write-Host $Locale.GachaMenuChooseLink
    foreach ($option in $Locale.RegionOptionsNoCloud) {
        Write-Host $option
    }
}

function Get-Gacha_os {
    Invoke-ScriptFromUrl -ScriptPath "gacha_clipboard/get_warp_link_os.ps1"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Get-Gacha_cn {
    Invoke-ScriptFromUrl -ScriptPath "gacha_clipboard/get_warp_link_cn.ps1"
    Write-Host $Locale.TaskCompleted
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Close-Clear
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Invoke-ScriptFromUrl -ScriptPath "cleanup.ps1"
    [Environment]::Exit(0)
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


