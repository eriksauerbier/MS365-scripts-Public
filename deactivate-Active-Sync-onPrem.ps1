# Alle Postfächer abrufen
Get-CASMailbox -ResultSize Unlimited | Where-Object {$_.ActiveSyncEnabled -eq $true} | ForEach-Object {
    Write-Host "Deaktiviere ActiveSync für: $($_.Identity)"
    Set-CASMailbox -Identity $_.Identity -ActiveSyncEnabled $false
}