# Skript ändern der ImmutableID aus einer CSV
# Stannek GmbH v.1.0 - 03.01.2025 - E.Sauerbier

# Assembly für Hinweisboxen laden
[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Parameter
$WorkPath = If($PSISE){Split-Path -Path $psISE.CurrentFile.FullPath}else{Split-Path -Path $MyInvocation.MyCommand.Path}
IF ($Null -eq $WorkPath) {$WorkPath = Split-Path $psEditor.GetEditorContext().CurrentFile.Path} #Falls Skript in VS Code ausgefuehrt wird

# PS-Modul für AzureAD laden oder installieren
if ($InstalledModule.Name -notcontains "AzureAD") {Install-Module -Name AzureAD -Scope CurrentUser -AllowClobber -Force -Verbose -ErrorVariable InstallError}
else {Update-Module AzureAD -Scope CurrentUser -Verbose -ErrorVariable InstallError}

# PS-Modul fuer AzureAD laden
Import-Module AzureAD -ErrorVariable LoadError -Verbose

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

# Mit AzureAD verbinden
Connect-AzureAd -Verbose -ErrorAction Stop

# CSV-Importdatei ausw�hlen
$CSVFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$CSVFileDialog.initialDirectory = $WorkPath
$CSVFileDialog.filter = "CSV (*.csv)| *.csv"
$CSVFileDialog.ShowDialog() | Out-Null

# Inhalt der CSV auslesen
$Users = Import-CSV -Path $CSVFileDialog.filename -Delimiter ","

# ImmutableID für alle Benutzer setzen
foreach ($User in $Users) {
    # ObjectID auslesen
    $UserObjectID = Get-AzureADUser -All $True | Select-Object UserPrincipalName, ObjectID | Where-Object {$_.UserPrincipalName -eq $User.UPN}
    # neue ImmutableID setzen
    Set-AzureADUser -ObjectId $UserObjectID.ObjectId -ImmutableId $User.ImmutableID -Verbose
}

# ImmutableID für alle Benutzer anzeigen
Get-AzureADUser | Select-Object UserPrincipalName, ImmutableID

Read-Host "Zum beenden beliebige Taste druecken"

# Shell beenden
Disconnect-AzAccount