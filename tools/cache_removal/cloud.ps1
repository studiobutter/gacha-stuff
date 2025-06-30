# Define the log directories to check
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
            Write-Host "Deleted: $logFile"
        } else {
            Write-Host "Log file not found in: $dir"
        }
    } else {
        Write-Host "Directory does not exist: $dir"
    }
}
