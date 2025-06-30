# Requires -RunAsAdministrator

function Get-GameRegistryPaths {
    return @(
        @{ Name = 'Genshin Impact (Global - Default)';    RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\hk4e_global';    Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = 'Genshin Impact (Global - Epic)';       RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\hk4e_global\8fANlj5K7I\hk4e_global'; Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = 'Genshin Impact (Global - Google Play)';RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_6\hk4e_global\8fANlj5K7I\hk4e_global'; Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = 'Genshin Impact (China - Default)';     RegPath = 'HKCU:Software\miHoYo\HYP\1_1\hk4e_cn';         Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = 'Genshin Impact (China - QQ)';      RegPath = 'HKCU:Software\miHoYo\HYP\1_2\hk4e_cn';         Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = 'Genshin Impact (China - BiliBili)';    RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\hk4e_cn\umfgRO5gh5\hk4e_cn'; Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = 'Honkai: Star Rail (Global - Default)'; RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\hkrpg_global'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = 'Honkai: Star Rail (Global - Epic)';    RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\hkrpg_global\gGoJxKOusQ\hkrpg_global'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = 'Honkai: Star Rail (China - Default)';  RegPath = 'HKCU:Software\miHoYo\HYP\1_1\hkrpg_cn';        Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = 'Honkai: Star Rail (China - QQ)';   RegPath = 'HKCU:Software\miHoYo\HYP\1_2\hkrpg_cn';        Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = 'Honkai: Star Rail (China - BiliBili)'; RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\hkrpg_cn\6P5gHMNyK3\hkrpg_cn'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = 'Zenless Zone Zero (Global - Default)'; RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\nap_global'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = 'Zenless Zone Zero (Global - Epic)';    RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\nap_global\0hUu4SbmhI\nap_global'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = 'Zenless Zone Zero (China - Default)';  RegPath = 'HKCU:Software\miHoYo\HYP\1_1\nap_cn';          Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = 'Zenless Zone Zero (China - QQ)';   RegPath = 'HKCU:Software\miHoYo\HYP\1_2\nap_cn';          Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = 'Zenless Zone Zero (China - BiliBili)'; RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\nap_cn\xV0f4r1GT0\nap_cn'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; }
    )
}

function Get-InstalledGames {
    $games = @()
    foreach ($entry in Get-GameRegistryPaths) {
        if (Test-Path $entry.RegPath) {
            $installPath = (Get-ItemProperty -Path $entry.RegPath -ErrorAction SilentlyContinue).GameInstallPath
            if ($installPath) {
                $games += [PSCustomObject]@{
                    Name = $entry.Name
                    RegPath = $entry.RegPath
                    InstallPath = $installPath
                    Type = $entry.Type
                    DataFolder = $entry.DataFolder
                    CacheRemoved = $false
                }
            }
        }
    }
    return $games
}

function Remove-GameCache {
    param(
        $game
    )
    $cacheRoot = Join-Path $game.InstallPath $game.DataFolder
    switch ($game.Type) {
        'Genshin'   { $cacheDir = Join-Path $cacheRoot 'webCaches' }
        'StarRail'  { $cacheDir = Join-Path $cacheRoot 'webCaches' }
        'ZZZ'       { $cacheDir = Join-Path $cacheRoot 'webCaches' }
        default     { return }
    }
    if (!(Test-Path $cacheDir)) {
        Write-Host "No cache directory found for $($game.Name)." -ForegroundColor Yellow
        return
    }
    $versions = Get-ChildItem -Path $cacheDir -Directory | Sort-Object Name
    if ($versions.Count -eq 0) {
        Write-Host "No cache versions found in $cacheDir." -ForegroundColor Yellow
        return
    }
    $latest = $versions[-1]
    $oldVersions = $versions | Where-Object { $_.Name -ne $latest.Name }
    foreach ($ver in $oldVersions) {
        try {
            Remove-Item -Path $ver.FullName -Recurse -Force -ErrorAction Stop
            Write-Host "Removed old cache version: $($ver.Name)" -ForegroundColor Green
        } catch {
            Write-Host "Failed to remove $($ver.Name): $_" -ForegroundColor Red
        }
    }
    $cacheData = Join-Path $latest.FullName 'Cache\Cache_Data'
    if (Test-Path $cacheData) {
        try {
            Get-ChildItem -Path $cacheData -File | Remove-Item -Force
            Write-Host "Cleared Chromium cache files in $($latest.Name)." -ForegroundColor Green
        } catch {
            Write-Host "Failed to clear Chromium cache: $_" -ForegroundColor Red
        }
    }
}

function Show-Menu {
    param($games)
    Clear-Host
    Write-Host "== HoYo Cache Removal Tool ==`n" -ForegroundColor Cyan
    for ($i = 0; $i -lt $games.Count; $i++) {
        $status = if ($games[$i].CacheRemoved) { '[REMOVED]' } else { '' }
        Write-Host ("[{0}] {1} - {2} {3}" -f ($i+1), $games[$i].Name, $games[$i].InstallPath, $status)
    }
    Write-Host "[0] Exit"
}

# Main Loop
$games = Get-InstalledGames
if ($games.Count -eq 0) {
    Write-Host "No supported HoYo games found installed." -ForegroundColor Yellow
    exit
}
do {
    Show-Menu $games
    $choice = Read-Host "Select a game to remove cache (number)"
    if ($choice -eq '0') { break }
    if ($choice -match '^[1-9][0-9]*$' -and $choice -le $games.Count) {
        $idx = [int]$choice - 1
        if (-not $games[$idx].CacheRemoved) {
            Remove-GameCache $games[$idx]
            $games[$idx].CacheRemoved = $true
        } else {
            Write-Host "Cache already removed for this game." -ForegroundColor Yellow
        }
        Start-Sleep -Seconds 2
    }
} while ($true)
Write-Host "Exiting..." -ForegroundColor Cyan
