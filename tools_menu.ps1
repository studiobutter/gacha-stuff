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
    Write-Host $Locale.ToolSelection
    foreach ($option in $Locale.ToolOptions) {
        Write-Host $option
    }
}

function Get-Cleaner {
    Invoke-ScriptFromUrl -ScriptPath "tools/cache_removal.ps1"
}

function Get-LangReset {
    Invoke-ScriptFromUrl -ScriptPath "tools/lang_reset.ps1"
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Invoke-ScriptFromUrl -ScriptPath "cleanup.ps1"
    [Environment]::Exit(0)
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