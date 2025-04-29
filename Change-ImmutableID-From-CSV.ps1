# Skript ändern der ImmutableID aus einer CSV
# Stannek GmbH v.1.1.1 - 29.04.2025 - E.Sauerbier

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Parameter
$WorkPath = If($PSISE){Split-Path -Path $psISE.CurrentFile.FullPath}else{Split-Path -Path $MyInvocation.MyCommand.Path}
IF ($Null -eq $WorkPath) {$WorkPath = Split-Path $psEditor.GetEditorContext().CurrentFile.Path} #Falls Skript in VS Code ausgefuehrt wird

# installierte Module auslesen
$InstalledModule = Get-InstalledModule

# PS-Modul fuer Microsoft Entra installieren oder updaten
if ($InstalledModule.Name -notcontains "Microsoft.Entra") {Install-Module -Name Microsoft.Entra -Scope CurrentUser -AllowClobber -Force -Verbose}
else {Update-Module Microsoft.Entra -Verbose}

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

# Mit Entra Shell verbinden
Connect-Entra -Scopes 'User.ReadWrite.All' -Verbose -ErrorAction Stop

# CSV-Importdatei auswählen
$CSVFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$CSVFileDialog.initialDirectory = $WorkPath
$CSVFileDialog.filter = "CSV (*.csv)| *.csv"
$CSVFileDialog.ShowDialog() | Out-Null

# Inhalt der CSV auslesen
$Users = Import-CSV -Path $CSVFileDialog.filename -Delimiter ","

# ImmutableID für alle Benutzer setzen
foreach ($User in $Users) {
    # ObjectID auslesen
    $UserObjectID = Get-EntraUser -UserID $User.UPN | Select-Object UserPrincipalName, ObjectID
    # neue ImmutableID setzen
    Set-EntraUser -UserId $UserObjectID.ObjectId -ImmutableId $User.ImmutableID -Verbose
}

# ImmutableID für alle Benutzer anzeigen
Get-EntraUser | Select-Object UserPrincipalName, ImmutableID

Read-Host "Zum beenden beliebige Taste druecken"

# Shell beenden
Disconnect-Entra