param (
    [string]$InputDir = "i18n",
    [string]$OutputDir = "crowdin"
)

if (!(Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
}

Get-ChildItem -Path $InputDir -Recurse -Filter "*.psd1" | ForEach-Object {
    $lang = Split-Path $_.DirectoryName -Leaf
    $data = Invoke-Expression -Command ". `"$($_.FullName)`""

    $jsonPath = Join-Path -Path $OutputDir -ChildPath "$lang.json"
    $jsonContent = $data | ConvertTo-Json -Depth 5
    Set-Content -Path $jsonPath -Value $jsonContent -Encoding UTF8
    Write-Host "Converted $($_.FullName) → $jsonPath"
}
