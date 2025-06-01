Remove-Item -Path (Join-Path $env:TMP 'gacha-log') -Recurse -Force -ErrorAction SilentlyContinue

exit 0