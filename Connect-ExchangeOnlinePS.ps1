# Skript zum verbinden der Exchange Online Shell
# Stannek GmbH v.1.03 - 20.01.2022 - E.Sauerbier

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# PS-Modul für Exchange Online laden oder installieren
If (!(Get-InstalledModule -Name ExchangeOnlineManagement -ErrorAction SilentlyContinue)) {Install-Module -Name ExchangeOnlineManagement -AllowClobber -Force -Verbose -Scope CurrentUser -ErrorVariable InstallError}
import-Module ExchangeOnlineManagement -ErrorVariable LoadError

if ($InstallError -ne $Null) {
      $header = "Fehler beim Installieren des PS-Module"
      $msg = "Das PS-Module ExchangeInlineManagement konnte nicht installiert werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Error
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

if ($LoadError -ne $Null) {
      $header = "Fehler beim Laden des PS-Module"
      $msg = "Das PS-Module ExchangeOnlineManagement konnte nicht geladen werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Warning
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

# Neue PS-Session starten und mit der AzureAD Shell verbinden
$Argument = "-NoExit -Command Connect-ExchangeOnline"
Start-Process Powershell.exe -ArgumentList $Argument

# Verbindung zur Shell trennen
Disconnet-ExchangeOnline