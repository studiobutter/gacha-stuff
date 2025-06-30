# Requires -RunAsAdministrator
# HoYo Cache Removal Script

function Get-UserName {
    return [System.Environment]::UserName
}

function Get-GamePaths {
    $user = Get-UserName
    return @(
        @{ Name = "Genshin Impact (Global)";    Path = "C:\Users\$user\AppData\LocalLow\miHoYo\Genshin Impact";      Log = @("output_log.txt", "output_log-old.txt");   DataPattern = "GenshinImpact_Data" },
        @{ Name = "Genshin Impact (China)";     Path = "C:\Users\$user\AppData\LocalLow\miHoYo\原神";                Log = @("output_log.txt", "output_log-old.txt");   DataPattern = "YuanShen_Data" },
        @{ Name = "Honkai: Star Rail (Global)"; Path = "C:\Users\$user\AppData\LocalLow\Cognosphere\Star Rail";      Log = @("Player.log", "Player-prev.log");          DataPattern = "StarRail_Data" },
        @{ Name = "Honkai: Star Rail (China)";  Path = "C:\Users\$user\AppData\LocalLow\miHoYo\崩坏：星穹铁道";        Log = @("Player.log", "Player-prev.log");          DataPattern = "StarRail_Data" },
        @{ Name = "Zenless Zone Zero (Global)"; Path = "C:\Users\$user\AppData\LocalLow\miHoYo\ZenlessZoneZero";     Log = @("Player.log", "Player-prev.log");          DataPattern = "ZenlessZoneZero_Data" },
        @{ Name = "Zenless Zone Zero (China)";  Path = "C:\Users\$user\AppData\LocalLow\miHoYo\绝区零";                Log = @("Player.log", "Player-prev.log");          DataPattern = "ZenlessZoneZero_Data" }
    )
}

function Get-DataDirsFromLog {
    param(
        [string]$logPath,
        [string]$dataPattern
    )
    $dirs = @()
    if (Test-Path $logPath) {
        $lines = Get-Content $logPath -Raw | Select-String -Pattern $dataPattern -AllMatches | ForEach-Object { $_.Line }
        foreach ($line in $lines) {
            if ($dataPattern -eq "GenshinImpact_Data" -or $dataPattern -eq "YuanShen_Data") {
                if ($line -match "([A-Z]:[\\/].*?[\\/]" + [regex]::Escape($dataPattern) + ")") {
                    $dirs += $matches[1] -replace '/', '\'
                }
            } else {
                # Match both "at path ..." and "[Subsystems] Discovering subsystems at path ..." and both slashes
                if ($line -match "(?i)at path ([A-Z]:[\\/].*?[\\/]" + [regex]::Escape($dataPattern) + ")[\\/](UnitySubsystems)?") {
                    $dirs += $matches[1] -replace '/', '\'
                } elseif ($line -match "([A-Z]:[\\/].*?[\\/]" + [regex]::Escape($dataPattern) + ")[\\/](UnitySubsystems)?") {
                    $dirs += $matches[1] -replace '/', '\'
                }
            }
        }
    }
    return $dirs | Select-Object -Unique
}

function Get-GameDataDirs {
    param(
        [object]$game
    )
    $dirs = @()
    foreach ($log in $game.Log) {
        $logPath = Join-Path $game.Path $log
        $found = Get-DataDirsFromLog -logPath $logPath -dataPattern $game.DataPattern
        $dirs += $found
    }
    $dirs = $dirs | Select-Object -Unique
    # If both logs have different directories, check which exist
    $existing = $dirs | Where-Object { Test-Path $_ }
    return $existing
}

function Get-WebCachesPath {
    param(
        [string]$dataDir
    )
    return Join-Path $dataDir "webCaches"
}

function Remove-OldCacheVersions {
    param(
        [string]$webCachesPath
    )
    if (-not (Test-Path $webCachesPath)) { return $false }
    $versions = Get-ChildItem -Path $webCachesPath -Directory | Where-Object { $_.Name -match "^\d+\.\d+\.\d+\.\d+$" }
    if ($versions.Count -eq 0) { return $false }
    $latest = $versions | Sort-Object { [Version]$_.Name } | Select-Object -Last 1
    $old = $versions | Where-Object { $_.FullName -ne $latest.FullName }
    foreach ($dir in $old) {
        Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }
    return $latest.FullName
}

function Clear-ChromiumCache {
    param(
        [string]$latestVersionPath
    )
    $cacheData = Join-Path $latestVersionPath "Cache\Cache_Data"
    if (Test-Path $cacheData) {
        Get-ChildItem -Path $cacheData -File | Remove-Item -Force -ErrorAction SilentlyContinue
    }
}

function Main {
    $games = Get-GamePaths
    $gameStates = @{}
    while ($true) {
        $available = @()
        $i = 1
        foreach ($game in $games) {
            if (Test-Path $game.Path) {
                $dataDirs = Get-GameDataDirs -game $game
                foreach ($dir in $dataDirs) {
                    $key = "$($game.Name) [$dir]"
                    if ($gameStates[$key] -eq "removed") {
                        Write-Host "$i. $key (cache removed)" -ForegroundColor DarkGray
                    } else {
                        Write-Host "$i. $key"
                        $available += @{ Index = $i; Game = $game; DataDir = $dir; Key = $key }
                    }
                    $i++
                }
            }
        }
        if ($available.Count -eq 0) {
            Write-Host "No games with cache found or all caches already removed."
            break
        }
        Write-Host "Select a game to remove its cache (or press Enter to exit):"
        $input = Read-Host
        if (-not $input) { break }
        $inputInt = 0
        if (-not [int]::TryParse($input, [ref]$inputInt)) {
            Write-Host "Invalid selection."
            continue
        }
        $selected = $available | Where-Object { $_.Index -eq $inputInt } | Select-Object -First 1
        if ($selected) {
            $webCaches = Get-WebCachesPath -dataDir $selected.DataDir
            $latest = Remove-OldCacheVersions -webCachesPath $webCaches
            if ($latest) {
                Clear-ChromiumCache -latestVersionPath $latest
                Write-Host "Cache cleared for $($selected.Key)."
                $gameStates[$selected.Key] = "removed"
            } else {
                Write-Host "No cache found for $($selected.Key)."
            }
        } else {
            Write-Host "Invalid selection."
        }
    }
}

# Ensure running as admin
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please run this script as Administrator."
    exit
}

Main