Remove-Item -Path (Join-Path $env:TMP 'gacha-log') -Recurse -Force -ErrorAction SilentlyContinue
Clear-Host

Write-Host "Cleanup complete. Temporary files removed. Exiting" -ForegroundColor Green
# Exit the script
exit 0