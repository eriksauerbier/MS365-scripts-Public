# Skript zum verbinden der AzureAD Shell
# Stannek GmbH v.1.01 - 28.12.2021 - E.Sauerbier

# Diese Skript muss als Administrator ausgeführt werden, ansonsten wird es nicht gestartet
#Requires -RunAsAdministrator

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# PS-Modul für AzureAD laden oder installieren

If (!(Get-Module AzureAD)) {Install-Module -Name AzureAD -AllowClobber -Force -Verbose}
import-Module AzureAD

if (!(Get-Module "AzureAD")) {
      $header = "Fehler beim Laden des PS-Module"
      $msg = "Das PS-Module AzureAD konnte nicht geladen werden"
      $Exclamation = [System.Windows.Forms.MessageBoxIcon]::Warning
      [System.Windows.Forms.Messagebox]::Show($msg,$header,0,$Exclamation)
      break
      }

# Mit der AzureAD Shell verbinden
Connect-AzureAD
