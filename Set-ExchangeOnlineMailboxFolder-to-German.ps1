# Skript zur Anpassung der ExchangeOnline Ordner-Namen
# Stannek GmbH  v.1.11 - 28.12.2021 - E.Sauerbier

# Diese Skript muss als Administrator ausgeführt werden, ansonsten wird es nicht gestartet
#Requires -RunAsAdministrator

If (!(Get-Module ExchangeOnlineManagement)) {Install-Module -Name ExchangeOnlineManagement}
import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -ErrorAction Stop

# Get-Mailbox | set-MailboxRegionalConfiguration -LocalizeDefaultFolderName:$true -Language de-DE -DateFormat "dd.MM.yyyy"

Get-Mailbox -ResultSize unlimited | ? {$_.RecipientTypeDetails -eq "UserMailbox"} | Set-MailboxRegionalConfiguration -Language "de-DE" -DateFormat "dd.MM.yyyy" -TimeFormat "HH:mm" -TimeZone "W. Europe Standard Time" -LocalizeDefaultFolderName
Get-Mailbox -ResultSize unlimited | ? {$_.RecipientTypeDetails -eq "SharedMailbox"} | Set-MailboxRegionalConfiguration -Language "de-DE" -DateFormat "dd.MM.yyyy" -TimeFormat "HH:mm" -TimeZone "W. Europe Standard Time" -LocalizeDefaultFolderName


# Ergebnis anzeigen
Get-Mailbox -ResultSize unlimited | ? {$_.RecipientTypeDetails -eq "UserMailbox"} | Get-MailboxRegionalConfiguration
Get-Mailbox -ResultSize unlimited | ? {$_.RecipientTypeDetails -eq "SharedMailbox"} | Get-MailboxRegionalConfiguration

