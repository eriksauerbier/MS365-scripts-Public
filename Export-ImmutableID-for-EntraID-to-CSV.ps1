# Dieses Skript exportiert die ImmutableID alle AD-User aus einer OU in eine CSV
# ERSTER SCHRITT
# Stannek GmbH v.1.0 - 02.01.2025 - E.Sauerbier

# Parameter
$FileOutputName = "AD-Benutzer-ImmutableID"+(Get-Date -Format dd-MM-yyyy)+".csv"
$WorkPath = If($PSISE){Split-Path -Path $psISE.CurrentFile.FullPath}else{Split-Path -Path $MyInvocation.MyCommand.Path}
IF ($Null -eq $WorkPath) {$WorkPath = Split-Path $psEditor.GetEditorContext().CurrentFile.Path} #Falls Skript in VS Code ausgefuehrt wird

# Ausgabedatei erzeugen
$FileOutput = Join-Path -Path $WorkPath -ChildPath $FileOutputName

# Organisationseinheit auswählen
$OU = Get-ADOrganizationalUnit -Filter * | Out-GridView -Title "Organisationseinheit auswählen" -PassThru

# Skript abbrechen wenn keine OU ausgewählt wurde
If ($OU -eq $Null) {Break}

# ADUser auslesen und in CSV exportiert
$Users = Get-ADUser -Filter * -SearchBase $Ou.DistinguishedName | Select-Object samaccountname, objectGuid, UserPrincipalName

# Immutable ID einzelner User konvertieren
foreach ($User in $Users) {
        # ImmutableID konvertieren
        $ConvID = [Convert]::ToBase64String([guid]::New($User.objectGuid).ToByteArray())
        # Username und konvertierte ImmutableID in Objekt-Variable schreiben
        $tempobj = @([pscustomobject]@{samaccountname=$User.samaccountname;UPN=$User.UserPrincipalName;ImmutableID=$ConvID})
        $Output += $tempobj
}

# Objekt in CSV exportieren
$Output | Export-Csv -Path $FileOutput -NoTypeInformation