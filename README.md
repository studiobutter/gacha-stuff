# Gacha Tracker

This is the Repository for all PowerShell Files to copy your Gacha Links. Now with support for Multiple Languages.

To add your own language, please fork this repository, update the `language.json` file and add your language translation in the `i18n` folder

Run the Interactive menu:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/studiobutter/gacha-stuff/refs/heads/main/start.ps1'))}"
```

Cloudflare - Interactive Menu:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://gacha.studiobutter.io.vn/start.ps1?ref_type=heads'))}"
```

Credits:

[paimon.moe](https://github.com/MadeBaruna/paimon-moe)

[Star Rail Station](https://starrailstation.com/en)

[zzz.rng.moe](https://zzz.rng.moe/en)

## Developing Locally

```powershell
$env:GACHA_LOCAL_TEST = "true"
$env:GACHA_LOCAL_PATH = "C:\path\to\your\local\repo"
.\start.ps1
```
