# Prompt user to choose which URL to copy
$choice = Read-Host "不支持国际服的调频记录链接，请输入'2'复制中国服务器的调频记录链接"

# Define the paths to the log files in %localappdata%
# $GlobalPath = "$env:LOCALAPPDATA\HoYoverse\ZenlessZoneZeroCloud\config\logs\MiHoYoSDK.log"
$CNPath = "$env:LOCALAPPDATA\miHoYo\ZenlessZoneZeroCloud\config\logs\MiHoYoSDK.log"

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
        Clear-Host
        Write-Host "Zenless Zone Zero - Cloud Global is not supported yet."
    }
    "2" {
        $pattern = '"url":"https://webstatic.mihoyo.com/nap/event/e20230424gacha/'
        $gachaCN = Get-LastMatchingURL -filePath $CNPath -pattern $pattern

        if ($gachaCN) {
            $gachaCN | Set-Clipboard
            Write-Output "抽卡日志 URL 已复制到剪贴板: $gachaCN"
            Write-Output "将其粘贴到您最喜欢的祈愿记录保存程序"
        } else {
            Write-Output "未找到匹配的 URL。请在游戏中打开祈愿历史。"
        }
    }
    default {
        Write-Output "无效选择。请再次运行该命令。"
    }
}
