# Skript zum verbinden der AzureAD Shell
# Stannek GmbH v.1.03 - 20.01.2022 - E.Sauerbier

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# PS-Modul für AzureAD laden oder installieren

If (!(Get-InstalledModule -Name AzureAD -ErrorAction SilentlyContinue)) {Install-Module -Name AzureAD -AllowClobber -Force -Verbose -Scope CurrentUser -ErrorVariable InstallError}
import-Module AzureAD -ErrorVariable LoadError

if ($InstallError -ne $Null) {
      $header = "Fehler beim Installieren des PS-Module"
      $msg = "Das PS-Module AzureAD konnte nicht installiert werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Error
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

if ($LoadError -ne $Null) {
      $header = "Fehler beim Laden des PS-Module"
      $msg = "Das PS-Module AzureAD konnte nicht geladen werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Warning
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

# Neue PS-Session starten und mit der AzureAD Shell verbinden
$Argument = "-NoExit -Command Connect-AzureAD"
Start-Process Powershell.exe -ArgumentList $Argument

# Verbindung zur Shell trennen
Disconnet-AzureAD
