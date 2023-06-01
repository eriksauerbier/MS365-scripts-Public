# Skript zur Anpassung der ExchangeOnline Ordner-Namen
# Stannek GmbH  v.1.14 - 01.06.2023 - E.Sauerbier

# Diese Skript muss als Administrator ausgeführt werden, ansonsten wird es nicht gestartet
#Requires -RunAsAdministrator

#Parameter
$Language = "de-DE"
$DateFormat = "dd.MM.yyyy"
$TimeFormat = "HH:mm"
$TimeZone = "W. Europe Standard Time"

If (!(Get-Module ExchangeOnlineManagement)) {Install-Module -Name ExchangeOnlineManagement}
import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -ErrorAction Stop

# Alle Benutzer Postfächer auslesen und Regional-Konfiguration anpassen

$ChangedMailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox, SharedMailbox, RoomMailbox, EquipmentMailbox | Get-MailboxRegionalConfiguration | Where-Object {$_.Language -ne $Language}
$ChangedMailboxes | Set-MailboxRegionalConfiguration -Language $Language -DateFormat $DateFormat -TimeFormat $TimeFormat -TimeZone $TimeZone -LocalizeDefaultFolderName:$true

# Verbindung zu ExchangeOnline Shell beenden

Disconnect-ExchangeOnline

# Ergebnis anzeigen
Write-host "Folgende Postfächer wurden angepasst: " $ChangedMailboxes.Identity
Read-Host "Zum beenden beliebige Taste drücken"
