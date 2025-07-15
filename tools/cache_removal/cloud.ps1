# Define the log directories to check

$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

$input = Read-Host $Locale.CloudContinuePrompt
if ($input -eq "Q") {
    Write-Host $Locale.CloudNoFilesDeleted
    break
}
$logDirs = @(
    "$env:LOCALAPPDATA\miHoYo\GenshinImpactCloudGame\config\logs",
    "$env:LOCALAPPDATA\HoYoverse\GenshinImpactCloudGame\config\logs",
    "$env:LOCALAPPDATA\miHoYo\ZenlessZoneZeroCloud\config\logs"
)

foreach ($dir in $logDirs) {
    if (Test-Path $dir) {
        $logFile = Join-Path $dir 'MiHoYoSDK.log'
        if (Test-Path $logFile) {
            Remove-Item $logFile -Force
            Write-Host $Locale.CloudLogFileDeleted $logFile
        } else {
            Write-Host $Locale.CloudLogFileNotFound $logFile
        }
    } else {
        Write-Host $Locale.CloudDirectoryNotFound $dir
    }
}
Write-Host $Locale.GachaMenuAnyKey -ForegroundColor Yellow
