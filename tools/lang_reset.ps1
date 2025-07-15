# Prompt user to confirm language reset
$gachaLogTmp = "$env:TMP\gacha-log"

Import-LocalizedData -BaseDirectory $gachaLogTmp -FileName 'Gacha.Resources.psd1' -BindingVariable Locale

$answer = Read-Host $Locale.LanguageResetPrompt

if ($answer -eq 'y') {
    # Remove 'lang' value from registry
    Remove-ItemProperty -Path 'HKCU:\Software\gacha-log' -Name 'lang' -ErrorAction SilentlyContinue
    Write-Host $Locale.LanguageResetSuccess
    break
} elseif ($answer -eq 'n') {
    Write-Host $Locale.LanguageResetCancelled
} else {
    Write-Host $Locale.LanguageResetInvalidInput
}
