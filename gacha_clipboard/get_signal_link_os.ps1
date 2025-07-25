# Script made by Star Rail Station under the Apache License. Remade by rng.moe for Zenless Zone Zero.
#
# Read the Licenses here: http://www.apache.org/licenses/LICENSE-2.0

$gachaLogTmp = "$env:TMP\gacha-log"
Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

Add-Type -AssemblyName System.Web

$ProgressPreference = 'SilentlyContinue'

$game_path = ""

Write-Output $Locale.AttemptingToLocate

if ($set_path) {
    $game_path = $set_path
} else {
    $app_data = [Environment]::GetFolderPath('ApplicationData')
    $locallow_path = "$app_data\..\LocalLow\miHoYo\ZenlessZoneZero\"

    $log_path = "$locallow_path\Player.log"

    if (-Not [IO.File]::Exists($log_path)) {
        Write-Output $Locale.NoURL
        return
    }

    $log_lines = Get-Content $log_path -First 16

    if ([string]::IsNullOrEmpty($log_lines)) {
        $log_path = "$locallow_path\Player-prev.log"

        if (-Not [IO.File]::Exists($log_path)) {
            Write-Output $Locale.NoURL
            return
        }

        $log_lines = Get-Content $log_path -First 16
    }

    if ([string]::IsNullOrEmpty($log_lines)) {
        Write-Output $Locale.FailedToLocatePath1
        Write-Output $Locale.ScriptProvider1
        return
    }

    $log_lines = $log_lines.split([Environment]::NewLine)

    for ($i = 0; $i -lt 16; $i++) {
        $log_line = $log_lines[$i]

        if ($log_line.startsWith("[Subsystems] Discovering subsystems at path ")) {
            $game_path = $log_line.replace("[Subsystems] Discovering subsystems at path ", "").replace("UnitySubsystems", "")
            break
        }
    }
}

if ([string]::IsNullOrEmpty($game_path)) {
    Write-Output $Locale.FailedToLocatePath2
    Write-Output $Locale.ScriptProvider1
    return
}

$copy_path = [IO.Path]::GetTempPath() + [Guid]::NewGuid().ToString()

$cache_path = "$game_path/webCaches/Cache/Cache_Data/data_2"
$cache_folders = Get-ChildItem "$game_path/webCaches/" -Directory
$max_version = 0

for ($i = 0; $i -le $cache_folders.Length; $i++) {
    $cache_folder = $cache_folders[$i].Name
    if ($cache_folder -match '^\d+\.\d+\.\d+\.\d+$') {
        $version = [int]-join($cache_folder.Split("."))
        if ($version -ge $max_version) {
            $max_version = $version
            $cache_path = "$game_path/webCaches/$cache_folder/Cache/Cache_Data/data_2"
        }
    }
}

Copy-Item -Path $cache_path -Destination $copy_path
$cache_data = Get-Content -Encoding UTF8 -Raw $copy_path
Remove-Item -Path $copy_path

$cache_data_split = $cache_data -split '1/0/'

for ($i = $cache_data_split.Length - 1; $i -ge 0; $i--) {
    $line = $cache_data_split[$i]

    if ($line.StartsWith('http') -and $line.Contains("getGachaLog")) {
        $url = ($line -split "\0")[0]

        $res = Invoke-WebRequest -Uri $url -ContentType "application/json" -UseBasicParsing | ConvertFrom-Json

        if ($res.retcode -eq 0) {
            $uri = [Uri]$url
            $query = [Web.HttpUtility]::ParseQueryString($uri.Query)

            $keys = $query.AllKeys
            foreach ($key in $keys) {
                # Retain required params
                if ($key -eq "authkey") { continue }
                if ($key -eq "authkey_ver") { continue }
                if ($key -eq "sign_type") { continue }
                if ($key -eq "game_biz") { continue }
                if ($key -eq "lang") { continue }

                $query.Remove($key)
            }

            $latest_url = $uri.Scheme + "://" + $uri.Host + $uri.AbsolutePath + "?" + $query.ToString()

            Write-Output $Locale.URLFound
            Write-Output $latest_url
            Set-Clipboard -Value $latest_url
            Write-Output $Locale.Copied
            Write-Output $Locale.PasteInstructions
            return;
        }
    }
}

Write-Output $Locale.NoURL