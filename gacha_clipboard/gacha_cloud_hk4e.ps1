# Script made by Studio Butter for Genshin Impact - Cloud (Global and CN)

$gachaLogTmp = "$env:TMP\gacha-log"
Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

Clear-Host
# Prompt user to choose which URL to copy
$choice = Read-Host $Locale.CloudChoice

# Define the paths to the log files in %localappdata%
$GlobalPath = "$env:LOCALAPPDATA\HoYoverse\GenshinImpactCloudGame\config\logs\MiHoYoSDK.log"
$CNPath = "$env:LOCALAPPDATA\miHoYo\GenshinImpactCloudGame\config\logs\MiHoYoSDK.log"

# Function to get the last matching URL from a log file
function Get-LastMatchingURL {
    param (
        [string]$filePath,
        [string]$pattern
    )

    # Read all lines from the log file
    $logLines = Get-Content -Path $filePath

    # Initialize variable to store the matching URL
    $matchingURL = ""

    # Loop through each line and match the URL
    foreach ($line in $logLines) {
        if ($line -match $pattern) {
            $matchingURL = $line
        }
    }

    # Extract the URL value
    if ($matchingURL -match '"url":"([^"]+)"') {
        return $matches[1]
    } else {
        return $null
    }
}

# Determine which URL to copy based on user's choice
switch ($choice.ToLower()) {
    "1" {
        $pattern = '"url":"https://gs.hoyoverse.com/'
        $gachaGlobal = Get-LastMatchingURL -filePath $GlobalPath -pattern $pattern

        if ($gachaGlobal) {
            $gachaGlobal | Set-Clipboard
            Write-Output ($Locale.Copied + " " + $gachaGlobal)
            Write-Output ($Locale.PasteInstructions)
        } else {
            Write-Output $Locale.NoURL
        }
    }
    "2" {
        $pattern = '"url":"https://webstatic.mihoyo.com/hk4e/event/e20190909gacha-v3/'
        $gachaCN = Get-LastMatchingURL -filePath $CNPath -pattern $pattern

        if ($gachaCN) {
            $gachaCN | Set-Clipboard
            Write-Output ($Locale.Copied + " " + $gachaCN)
            Write-Output ($Locale.PasteInstructions)
        } else {
            Write-Output $Locale.NoURL
        }
    }
    default {
        Write-Output $Locale.InvalidChoice
    }
}
