rem Skript für die Migration des Outlook-Profils von OnPrem Exchange zu MS365
rem Stannek GmbH v.1.0 - 22.03.2022 - E.Sauerbier

rem Parameter

SET OutlookPath="C:\Program Files (x86)\Microsoft Office\root\Office16\Outlook.exe"
SET OSTPath1="%LocalAppData%\Microsoft\Outlook\*OST"
SET OSTPath2="%HomeDrive%\Outlook\*OST"
SET OutlookORGProfilePath="HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles"
SET OutlookCopyProfilePath="HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles.OnPREM"

rem Outlook starten um aktuelle Einstellungen zu prüfen

call %OutlookPath% 

pause

rem vorhandene OST-Dateien suchen und löschen

if Exist %OSTPath1% (del %OSTPath1%)
if Exist %OSTPath2% (del %OSTPath2%)

pause

rem Outlook-Profil löschen

reg copy %OutlookORGProfilePath% %OutlookCopyProfilePath% /s
reg Delete %OutlookORGProfilePath% /f

pause

rem AnmeldeInformationen löschen

control keymgr.dll

pause

rem Outlook starten

call %OutlookPath% 
