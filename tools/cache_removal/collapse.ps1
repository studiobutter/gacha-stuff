# Requires -RunAsAdministrator

$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

function Get-CollapseLauncherConfig {
    $basePath = "$env:LOCALAPPDATA\..\LocalLow\CollapseLauncher"
    $configPath = Join-Path $basePath 'config.ini'
    if (!(Test-Path $configPath)) {
        Write-Error $Locale.LauncherConfigNotFound
        return $null
    }
    $config = Get-Content $configPath | Where-Object { $_ -match '=' } | ForEach-Object {
        $parts = $_ -split '='
        [PSCustomObject]@{ Key = $parts[0].Trim(); Value = $parts[1].Trim() }
    }
    $dict = @{}
    foreach ($item in $config) { $dict[$item.Key] = $item.Value }
    return $dict
}

function Get-GameFolders {
    param($gameFolderPath)
    $gameFolders = @('GICN','GICNBiliBili','GIGlb','GiGlbGPlay','SRCN','HSRCNBiliBili','SRGlb','ZZZCN','ZZZBiliBili','ZZZGlb')
    $foundGames = @()
    $dataFolders = @{
        'GIGlb' = 'GenshinImpact_Data'
        'GiGlbGPlay' = 'GenshinImpact_Data'
        'GICN' = 'YuanShen_Data'
        'GICNBiliBili' = 'YuanShen_Data'
        'SRCN' = 'StarRail_Data'
        'HSRCNBiliBili' = 'StarRail_Data'
        'SRGlb' = 'StarRail_Data'
        'ZZZCN' = 'ZenlessZoneZero_Data'
        'ZZZBiliBili' = 'ZenlessZoneZero_Data'
        'ZZZGlb' = 'ZenlessZoneZero_Data'
    }
    $gameNames = @{
        'GIGlb' = $Locale.hk4e_global
        'GiGlbGPlay' = $Locale.hk4e_global_gplay
        'GICN' = $Locale.hk4e_cn
        'GICNBiliBili' = $Locale.hk4e_cn_b
        'SRCN' = $Locale.hkrpg_cn
        'HSRCNBiliBili' = $Locale.hkrpg_cn_b
        'SRGlb' = $Locale.hkrpg_global
        'ZZZCN' = $Locale.nap_cn
        'ZZZBiliBili' = $Locale.nap_cn_b
        'ZZZGlb' = $Locale.nap_global
    }
    foreach ($folder in $gameFolders) {
        $fullPath = Join-Path $gameFolderPath $folder
        $configPath = Join-Path $fullPath 'config.ini'
        if (Test-Path $configPath) {
            $gameConfig = Get-Content $configPath | Where-Object { $_ -match '=' } | ForEach-Object {
                $parts = $_ -split '='
                [PSCustomObject]@{ Key = $parts[0].Trim(); Value = $parts[1].Trim() }
            }
            $dict = @{}
            foreach ($item in $gameConfig) { $dict[$item.Key] = $item.Value }
            if ($dict.ContainsKey('game_install_path')) {
                $installPath = $dict['game_install_path']
                if ([string]::IsNullOrWhiteSpace($installPath)) { continue }
                $dataFolder = $dataFolders[$folder]
                if (!$dataFolder) { continue }
                $dataPath = Join-Path $installPath $dataFolder
                if (!(Test-Path $dataPath)) { continue }
                $hasData = (Get-ChildItem $dataPath -ErrorAction SilentlyContinue | Measure-Object).Count -gt 0
                if (-not $hasData) { continue }
                $foundGames += [PSCustomObject]@{
                    Name = $folder
                    Path = $installPath
                    DisplayName = $gameNames[$folder]
                }
            }
        }
    }
    return $foundGames
}

function Get-GameCacheInfo {
    param($game)
    $dataFolders = @{
        'GIGlb' = 'GenshinImpact_Data'
        'GiGlbGPlay' = 'GenshinImpact_Data'
        'GICN' = 'YuanShen_Data'
        'GICNBiliBili' = 'YuanShen_Data'
        'SRCN' = 'StarRail_Data'
        'HSRCNBiliBili' = 'StarRail_Data'
        'SRGlb' = 'StarRail_Data'
        'ZZZCN' = 'ZenlessZoneZero_Data'
        'ZZZBiliBili' = 'ZenlessZoneZero_Data'
        'ZZZGlb' = 'ZenlessZoneZero_Data'
    }
    $dataFolder = $dataFolders[$game.Name]
    if (!$dataFolder) { return $null }
    $dataPath = Join-Path $game.Path $dataFolder
    $webCachesPath = Join-Path $dataPath 'webCaches'
    return [PSCustomObject]@{
        DataPath = $dataPath
        WebCachesPath = $webCachesPath
    }
}

function Remove-OldCacheVersions {
    param($webCachesPath)
    if (!(Test-Path $webCachesPath)) { return $false }
    $versions = Get-ChildItem $webCachesPath -Directory | Sort-Object Name
    if ($versions.Count -eq 0) { return $false }
    $latest = $versions | Sort-Object Name -Descending | Select-Object -First 1
    $oldVersions = $versions | Where-Object { $_.Name -ne $latest.Name }
    foreach ($ver in $oldVersions) {
        Remove-Item $ver.FullName -Recurse -Force
    }
    # Remove Chromium cache files in latest version
    $cacheData = Join-Path $latest.FullName 'Cache\Cache_Data'
    if (Test-Path $cacheData) {
        Get-ChildItem $cacheData -File | Remove-Item -Force
    }
    return $true
}

$collapseConfig = Get-CollapseLauncherConfig
if (!$collapseConfig) { exit }
$gameFolderPath = $collapseConfig['GameFolder']
if (!(Test-Path $gameFolderPath)) {
    Write-Error $Locale.CollapseGameFolderNotFound
    exit
}
$games = Get-GameFolders $gameFolderPath
$status = @{}
while ($true) {
    Write-Host $Locale.GameInstalled
    for ($i=0; $i -lt $games.Count; $i++) {
        $game = $games[$i]
        $cacheInfo = Get-GameCacheInfo $game
        $removed = $status[$game.Name]
        $displayName = if ($game.PSObject.Properties.Match('DisplayName').Count -gt 0) { $game.DisplayName } else { $game.Name }
        $mark = if ($removed) { '[Cache Removed]' } else { '' }
        Write-Host "$($i+1). $displayName - $($game.Path) $mark"
    }
    Write-Host $Locale.GoBack
    $choice = Read-Host $Locale.GameCacheSelection
    if ($choice -eq '0') { break }
    if ($choice -match '^[1-9][0-9]*$' -and ($choice -le $games.Count)) {
        $idx = [int]$choice - 1
        $game = $games[$idx]
        $cacheInfo = Get-GameCacheInfo $game
        $displayName = if ($game.PSObject.Properties.Match('DisplayName').Count -gt 0) { $game.DisplayName } else { $game.Name }
        if ($cacheInfo) {
            $result = Remove-OldCacheVersions $cacheInfo.WebCachesPath
            if ($result) {
                Write-Host $Locale.GameCacheRemovedStatus $displayName
                $status[$game.Name] = $true
            } else {
                Write-Host $Locale.GameCacheNotFound $displayName
            }
        } else {
            Write-Host $Locale.GameDataFolderNotFound
        }
    } else {
        Write-Host $Locale.InvalidChoice -ForegroundColor Red
    }
}
