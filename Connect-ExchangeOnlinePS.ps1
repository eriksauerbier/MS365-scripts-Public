# Skript zum verbinden der Exchange Online Shell
# Stannek GmbH v.1.01 - 28.12.2021 - E.Sauerbier

# Diese Skript muss als Administrator ausgeführt werden, ansonsten wird es nicht gestartet
#Requires -RunAsAdministrator

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# PS-Modul für Exchange Online laden oder installieren
If (!(Get-Module ExchangeOnlineManagement)) {Install-Module -Name ExchangeOnlineManagement -AllowClobber -Force -Verbose}
import-Module ExchangeOnlineManagement

if (!(Get-Module "ExchangeOnlineManagement")) {
      $header = "Fehler beim Laden des PS-Module"
      $msg = "Das PS-Module ExchangeOnlineManagement konnte nicht geladen werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Warning
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

# Mit der Exchange Online Shell verbinden
Connect-ExchangeOnline
