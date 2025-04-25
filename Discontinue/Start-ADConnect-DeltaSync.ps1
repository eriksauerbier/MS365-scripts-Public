# Skript zum manuellen synchronisieren von AzureAD Connect
# Stannek GmbH v.1.01 - 28.12.2021 - E.Sauerbier

# AADC Module laden
Import-Module ADSync

#Start-ADSyncSyncCycle
Start-ADSyncSyncCycle -PolicyType Delta