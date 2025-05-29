# Check for Administrator rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Script is not running as Administrator. Attempting to relaunch with elevated privileges..."
    $pwshPath = (Get-Command pwsh.exe -ErrorAction SilentlyContinue)?.Source
    if ($pwshPath) {
        Start-Process $pwshPath "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
    } else {
        Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $args" -Verb RunAs
    }
    exit
}

$gachaLogTmp = "$env:TMP\gacha-log"
$regPath = 'HKCU:\Software\gacha-log'

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

if (-not (Test-Path -Path $gachaLogTmp)) {
    New-Item -Path $gachaLogTmp -ItemType Directory | Out-Null
}

# Check if the registry path exists
if (-not (Test-Path -Path $regPath)) {
    New-Item -Path $regPath -ItemType Directory | Out-Null
}

if ($args.Count -gt 0) {
    $inputText = $args -join ' '
    $confirmation = Read-Host ($Locale.RegRememberChoice -f $inputText)
    if ($confirmation -match '^[Yy]$') {
        Set-ItemProperty -Path $regPath -Name 'lang' -Value $inputText
        Write-Output $Locale.RegRememberSuccess

    } else {
        Write-Output $Locale.RegRememberCancelled
    }
} else {
    Write-Output "No text provided. Usage: ./saveReg.ps1 [text]"
}

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://github.com/studiobutter/gacha-stuff/raw/refs/heads/multi-lang_2/Copy-Menu.ps1'))}"