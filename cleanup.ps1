Remove-Item -Path (Join-Path $env:TMP 'gacha-log') -Recurse -Force -ErrorAction SilentlyContinue

taskkill -f -im pwsh.exe
taskkill -f -im powershell.exe

exit 1