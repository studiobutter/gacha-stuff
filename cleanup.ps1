Remove-Item -Path (Join-Path $env:TMP 'gacha-log') -Recurse -Force -ErrorAction SilentlyContinue

Get-Process | Where-Object {
    ($_.ProcessName -in @('WindowsTerminal', 'powershell', 'pwsh')) -and
    ($_.MainWindowTitle -eq 'Gacha Clipboard Catcher')
} | ForEach-Object {
    Stop-Process -Id $_.Id -Force
}

exit 1