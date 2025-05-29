Remove-Item -Path (Join-Path $env:TMP 'gacha-log') -Recurse -Force -ErrorAction SilentlyContinue

taskkill -f -im powershell.exe
taskkill -f -im pwsh.exe

exit 1