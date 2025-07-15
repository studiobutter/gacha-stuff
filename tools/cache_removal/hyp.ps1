# Requires -RunAsAdministrator

$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

function Get-GameRegistryPaths {
    return @(
        @{ Name = $Locale.hk4e_global;    RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\hk4e_global';    Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = $Locale.hk4e_global_gplay;       RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\hk4e_global\8fANlj5K7I\hk4e_global'; Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = $Locale.hk4e_global_epic;RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_6\hk4e_global\8fANlj5K7I\hk4e_global'; Type = 'Genshin';   DataFolder = 'GenshinImpact_Data'; },
        @{ Name = $Locale.hk4e_cn;     RegPath = 'HKCU:Software\miHoYo\HYP\1_1\hk4e_cn';         Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = $Locale.hk4e_cn_qq;      RegPath = 'HKCU:Software\miHoYo\HYP\1_2\hk4e_cn';         Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = $Locale.hk4e_cn_b;    RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\hk4e_cn\umfgRO5gh5\hk4e_cn'; Type = 'Genshin';   DataFolder = 'YuanShen_Data'; },
        @{ Name = $Locale.hkrpg_global; RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\hkrpg_global'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = $Locale.hkrpg_global_epic;    RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\hkrpg_global\gGoJxKOusQ\hkrpg_global'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = $Locale.hkrpg_cn;        RegPath = 'HKCU:Software\miHoYo\HYP\1_1\hkrpg_cn';        Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = $Locale.hkrpg_cn_qq;   RegPath = 'HKCU:Software\miHoYo\HYP\1_2\hkrpg_cn';        Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = $Locale.hkrpg_cn_b; RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\hkrpg_cn\6P5gHMNyK3\hkrpg_cn'; Type = 'StarRail'; DataFolder = 'StarRail_Data'; },
        @{ Name = $Locale.nap_global; RegPath = 'HKCU:Software\Cognosphere\HYP\1_0\nap_global'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = $Locale.nap_global_epic;    RegPath = 'HKCU:Software\Cognosphere\HYP\standalone\1_3\nap_global\0hUu4SbmhI\nap_global'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = $Locale.nap_cn;          RegPath = 'HKCU:Software\miHoYo\HYP\1_1\nap_cn';          Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = $Locale.nap_cn_qq;   RegPath = 'HKCU:Software\miHoYo\HYP\1_2\nap_cn';          Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; },
        @{ Name = $Locale.nap_cn_b; RegPath = 'HKCU:Software\miHoYo\HYP\standalone\14_0\nap_cn\xV0f4r1GT0\nap_cn'; Type = 'ZZZ';      DataFolder = 'ZenlessZoneZero_Data'; }
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
        Write-Host $Locale.GameCacheNotFound -ForegroundColor Yellow
        return
    }
    $versions = Get-ChildItem -Path $cacheDir -Directory | Sort-Object Name
    if ($versions.Count -eq 0) {
        Write-Host $Locale.GameCacheVerNotFound -ForegroundColor Yellow
        return
    }
    $latest = $versions[-1]
    $oldVersions = $versions | Where-Object { $_.Name -ne $latest.Name }
    foreach ($ver in $oldVersions) {
        try {
            Remove-Item -Path $ver.FullName -Recurse -Force -ErrorAction Stop
            Write-Host $Locale.GameCacheVerRemoved -f $ver.Name -ForegroundColor Green
        } catch {
            Write-Host $Locale.GameCacheVerFailed -f $ver.Name -ForegroundColor Red
        }
    }
    $cacheData = Join-Path $latest.FullName 'Cache\Cache_Data'
    if (Test-Path $cacheData) {
        try {
            Get-ChildItem -Path $cacheData -File | Remove-Item -Force
            Write-Host $Locale.GameCacheVerCleared -f $latest.Name -ForegroundColor Green
        } catch {
            Write-Host $Locale.GameCacheFailed -f $_ -ForegroundColor Red
        }
    }
}

function Show-Menu {
    param($games)
    Clear-Host
    for ($i = 0; $i -lt $games.Count; $i++) {
        $status = if ($games[$i].CacheRemoved) { '[REMOVED]' } else { '' }
        Write-Host ("[{0}] {1} - {2} {3}" -f ($i+1), $games[$i].Name, $games[$i].InstallPath, $status)
    }
    Write-Host $Locale.GoBack
}

# Main Loop
$games = Get-InstalledGames
if ($games.Count -eq 0) {
    Write-Host $Locale.GameDataNotFound -ForegroundColor Yellow
    exit
}
do {
    Show-Menu $games
    $choice = Read-Host $Locale.GameCacheSelection
    if ($choice -eq '0') { break }
    if ($choice -match '^[1-9][0-9]*$' -and $choice -le $games.Count) {
        $idx = [int]$choice - 1
        if (-not $games[$idx].CacheRemoved) {
            Remove-GameCache $games[$idx]
            $games[$idx].CacheRemoved = $true
        } else {
            Write-Host $Locale.GameCacheAlreadyRemoved -ForegroundColor Yellow
        }
        Start-Sleep -Seconds 2
    }
} while ($true)
Write-Host "Exiting..." -ForegroundColor Cyan
