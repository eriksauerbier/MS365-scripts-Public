rem Skript für die Migration des Outlook-Profils von OnPrem Exchange zu MS365
rem Stannek GmbH v.1.3.1 - 29.08.2022 - E.Sauerbier

rem Parameter

SET OutlookPath="C:\Program Files (x86)\Microsoft Office\root\Office16\Outlook.exe"
SET OSTPath1="%LocalAppData%\Microsoft\Outlook\*OST"
SET OSTPath2="%HomeDrive%\Outlook\*OST"
SET OutlookORGProfilePath="HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles"
SET OutlookCopyProfilePath="HKCU\Software\Microsoft\Office\16.0\Outlook\Profiles.OnPREM"
SET OutlookAutoDicoverPath="HKCU\Software\Microsoft\Office\16.0\Outlook\Autodiscover"
SET OutlookSettingsPath="HKCU\Software\Microsoft\Office\Outlook\Settings"

rem Outlook starten um aktuelle Einstellungen zu prüfen

call %OutlookPath% 

pause

rem vorhandene OST-Dateien suchen und löschen

if Exist %OSTPath1% (del %OSTPath1%)
if Exist %OSTPath2% (del %OSTPath2%)

pause

rem Outlook-Profil und Einstellungen löschen

reg copy %OutlookORGProfilePath% %OutlookCopyProfilePath% /s
reg Delete %OutlookORGProfilePath% /f
reg Delete %OutlookSettingsPath% /f

pause

rem AutoDiscover Einstellung zurücksetzen

reg Delete %OutlookAutoDicoverPath% /f

rem DATEV Office-Einstellung zurücksetzen

regedit /S "%DATEVPP%\PROGRAMM\BSOffice\Service auf die Datei SetOfficeAdapterToDefault_ALL.reg"

rem AnmeldeInformationen löschen

control keymgr.dll

pause

rem Outlook starten

call %OutlookPath% 
