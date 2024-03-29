﻿# Dieses Skript setzt im lokalen AD den UPN für die  Office 365 & Exchange Online Anmeldung
# Stannek GmbH v.1.1 - 17.03.2022 - E.Sauerbier

# User-OU auswählen
$OU = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName  | Out-GridView -PassThru -Title "OU der Benutzer auswählen"

# Falls Abbrechen geklickt wird, dann Skript beenden
If ($OU -eq $Null) {break}

# alle User aus OU auslesen
$Users = Get-ADUser -Filter * -SearchBase $OU.DistinguishedName -Properties Mail

# UPNSuffix aus Mail-Attribut eines Users auslesen
$users | foreach {if ($_.Mail -ne $Null) {$UPNSuffix = (($_.Mail).Split("@"))[1]}}

# Wenn kein UPN-Suffix ausgelesen wurde Skript abbrechen
if ($UPNSuffix -eq $Null) {Read-Host "Mail-Attribut im AD-User nicht gepflegt"; break}

# UPNSuffix im Forest setzen
Get-ADForest | Set-ADForest -UPNSuffixes @{add=$UPNSuffix}

# UPN Suffix bei den Usern anpassen, die das Mail-Attribut gepflegt haben
$Users | foreach {if ($_.Mail -ne $Null) { $_ | Set-ADUser -UserPrincipalName $_.Mail}}

