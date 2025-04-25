# Skript zum verbinden der Entra Shell
# Stannek GmbH v.1.0 - 25.04.2025 - E.Sauerbier

# Parameter
$ScopeEntraURW = 'User.ReadWrite.All'
$ScopeEntraUR = 'User.Read.All'

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# installierte Module auslesen
$InstalledModule = Get-InstalledModule

# PS-Modul fuer Microsoft Entra installieren oder updaten
if ($InstalledModule.Name -notcontains "Microsoft.Entra") {Install-Module -Name Microsoft.Entra -Scope CurrentUser -AllowClobber -Force -Verbose}
else {Update-Module Microsoft.Entra -Scope CurrentUser -Verbose}

# PS-Modul fuer EntraID laden
Import-Module Microsoft.Entra -ErrorVariable LoadError -Verbose

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

# Scope abfragen
$MBheader = "Scope auswählen"
$MBmsg = "Wird schreibender Zugriff auf die Entra Shell benoetigt?"
$MBicon = [System.Windows.Forms.MessageBoxIcon]::Question
$MBbuttons = "4"
# Messagebox ausgeben
$SelScope = [System.Windows.Forms.Messagebox]::Show($MBmsg,$MBheader,$MBbuttons,$MBicon)

# Ergebnis setzen
If ($SelScope -eq "Yes") {$ScopeEntra = $ScopeEntraURW}
Else {$ScopeEntra = $ScopeEntraUR}

# Mit Entra Shell verbinden
$ArgCommand = "Connect-Entra -Scopes $ScopeEntra -Verbose -ErrorAction Stop"

# Neue PS-Session starten und mit der AzureAD Shell verbinden
$Argument = "-NoExit -Command $ArgCommand"
Start-Process Powershell.exe -ArgumentList $Argument