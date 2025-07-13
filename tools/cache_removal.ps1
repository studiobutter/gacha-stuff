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

function Close-Clear {
    Write-Host $Locale.GachaMenuExit -ForegroundColor Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString($(Get-ScriptUrl "cleanup.ps1")))}"
    exit 0
}

# Main loop
while ($true) {
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
    $collapseEnabled = Test-Path $collapsePath

    Show-Menu -hoyoplayEnabled $hoyoplayEnabled -collapseEnabled $collapseEnabled
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
        "?" { Show-More }
        default { Write-Host $Locale.InvalidChoice -ForegroundColor Red; continue }
    }
}