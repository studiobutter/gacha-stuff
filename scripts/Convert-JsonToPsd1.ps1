param (
    [string]$JsonDir = "crowdin",
    [string]$Psd1Dir = "i18n"
)

Get-ChildItem -Path $JsonDir -Filter "*.json" | ForEach-Object {
    $lang = $_.BaseName
    $jsonContent = Get-Content $_.FullName -Raw | ConvertFrom-Json

    $psd1Path = Join-Path $Psd1Dir -ChildPath "$lang\Gacha.Resources.psd1"

    if (Test-Path $psd1Path) {
        $existing = Invoke-Expression -Command ". `"$psd1Path`""
        foreach ($key in $jsonContent.PSObject.Properties.Name) {
            $existing[$key] = $jsonContent[$key]
        }
    } else {
        $existing = @{}
        foreach ($key in $jsonContent.PSObject.Properties.Name) {
            $existing[$key] = $jsonContent[$key]
        }
    }

    $output = "@`n@{`n"
    foreach ($k in $existing.Keys) {
        $v = $existing[$k]
        if ($v -is [System.Collections.IEnumerable] -and !$v -is [string]) {
            $output += "    $k = @(`n"
            foreach ($item in $v) {
                $output += "        '$item',`n"
            }
            $output = $output.TrimEnd(",`n") + "`n    );`n"
        } else {
            $output += "    $k = '$v';`n"
        }
    }
    $output += "}`n"

    Set-Content -Path $psd1Path -Value $output -Encoding UTF8
    Write-Host "Updated $psd1Path with translations from $($_.FullName)"
}
