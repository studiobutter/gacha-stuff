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

function Show-Menu {
    param (
        [bool]$hoyoplayEnabled,
        [bool]$collapseEnabled
    )
    Write-Host $Locale.ToolSelection
    Write-Host $Locale.CleanerOptions[0] # 0: Exit
    Write-Host $Locale.CleanerOptions[1] # 1: No Launcher
    if ($hoyoplayEnabled) {
        Write-Host $Locale.CleanerOptions[2] # 2: HoYoPlay
    } else {
        Write-Host "$($Locale.CleanerOptions[2]) [$($Locale.Disabled)]" -ForegroundColor DarkGray
    }
    if ($collapseEnabled) {
        Write-Host $Locale.CleanerOptions[3] # 3: CollapseLauncher
    } else {
        Write-Host "$($Locale.CleanerOptions[3]) [$($Locale.Disabled)]" -ForegroundColor DarkGray
    }
    Write-Host $Locale.CleanerOptions[4] # ?: More Info
}

function Show-Menu {
    Write-Host $Locale.ToolSelection
    foreach ($option in $Locale.CleanerOptions) {
        Write-Host $option
    }
}

function Invoke-NoLauncher {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/no_launcher.ps1")))}"
}

function Invoke-HoYoPlay {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/hyp.ps1")))}"
}

function Invoke-Collapse {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/collapse.ps1")))}"
}

function Invoke-Cloud {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "tools/cache_removal/cloud.ps1")))}"
}

function Show-More {
    Clear-Host
    Write-Host $Locale.ToolCleanerDisclaimer1
    Write-Host $Locale.ToolCleanerDisclaimer2
    foreach ($item in $Locale.ToolCleanerDisclaimer3) {
        Write-Host $item
    }
    Write-Host $Locale.ToolCleanerDisclaimer4
    Write-Host $Locale.ToolCleanerDisclaimer5
    Write-Host $Locale.ToolCleanerDisclaimer6
    Write-Host $Locale.ToolCleanerDisclaimer7
    Write-Host $Locale.ToolCleanerDisclaimer8
    Write-Host $Locale.ToolCleanerDisclaimer9
    Write-Host $Locale.ToolCleanerDisclaimerLink
    Write-Host $Locale.ToolCleanerAnyKey -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Clear-Host
    Show-Menu
}

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "cleanup.ps1")))}"
    exit 0
}

# Main loop
while ($true) {
    Clear-Host
    # Re-run checks for each loop
    $regBase = 'HKCU:\Software\Classes'
    $regFolders = @(
        'HYP-cn-1-1',
        'HYP-cn-1-2',
        'HYP-cn-14-0-hk4e-cn-umfgRO5gh5',
        'HYP-cn-14-0-hkrpg-cn-6P5gHMNyK3',
        'HYP-cn-14-0-nap-cn-xV0f4r1GT0',
        'HYP-global-1-0',
        'HYP-global-1-6-hk4e-global-8fANlj5K7I'
    )
    $hoyoplayEnabled = $false
    foreach ($folder in $regFolders) {
        if (Test-Path (Join-Path $regBase $folder)) {
            $hoyoplayEnabled = $true
            break
        }
    }
    $collapsePath = Join-Path "$env:USERPROFILE\AppData\LocalLow" 'CollapseLauncher'
    $collapseEnabled = (Test-Path $collapsePath -PathType Container)

    $cloudBase = $env:LOCALAPPDATA
    $cloudFolders = @(
        'miHoYo/GenshinImpactCloudGame',
        'HoYoverse/GenshinImpactCloudGame',
        'miHoYo/ZenlessZoneZeroCloud'
    )
    $cloudEnabled = $false
    foreach ($folder in $cloudFolders) {
        if (Test-Path (Join-Path $cloudBase $folder)) {
            $cloudEnabled = $true
            break
        }
    }

    Show-Menu -hoyoplayEnabled $hoyoplayEnabled -collapseEnabled $collapseEnabled -cloudEnabled $cloudEnabled
    $choice = Read-Host $Locale.EnterChoice
    $choiceStr = "$choice"

    switch ($choiceStr) {
        "0" { Close-Clear }
        "1" { Invoke-NoLauncher }
        "2" {
            if ($hoyoplayEnabled) {
                Invoke-HoYoPlay
            } else {
                Write-Host $Locale.DisabledChoice -ForegroundColor Red
                continue
            }
        }
        "3" {
            if ($collapseEnabled) {
                Invoke-Collapse
            } else {
                Write-Host $Locale.DisabledChoice -ForegroundColor Red
                continue
            }
        }
        "4" {
            if ($cloudEnabled) {
                Clear-Host
                Invoke-Cloud
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            } else {
                Write-Host $Locale.DisabledChoice -ForegroundColor Red
                continue
            }
        }
        "?" { Show-More }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; continue }
    }
}