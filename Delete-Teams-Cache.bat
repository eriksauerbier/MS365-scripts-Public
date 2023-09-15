rem Skript zum loeschen des Teams Caches 
rem Stannek GmbH v.1.0 - 14.09.2023 - E.Sauerbier

rem beende Teams oder Teams Neu
taskkill /F /IM ms-teams.exe
taskkill /F /IM teams.exe
rem loesche Teams Cache
del /F/Q/S "%APPDATA%\Microsoft\Teams\blob_storage\*"
FOR /D %%p IN ("%APPDATA%\Microsoft\Teams\blob_storage\*") DO rmdir "%%p" /s /q
del /F/Q/S "%APPDATA%\Microsoft\Teams\cache\*"
del /F/Q/S "%APPDATA%\Microsoft\Teams\databases\*"
del /F/Q/S "%APPDATA%\Microsoft\Teams\gpucache\*"
del /F/Q/S "%APPDATA%\Microsoft\Teams\IndexedDB\*"
FOR /D %%p IN ("%APPDATA%\Microsoft\Teams\IndexedDB\*") DO rmdir "%%p" /s /q
del /F/Q/S "%APPDATA%\Microsoft\Teams\Local Storage\*"
FOR /D %%p IN ("%APPDATA%\Microsoft\Teams\Local Storage\*") DO rmdir "%%p" /s /q
del /F/Q/S "%APPDATA%\Microsoft\Teams\tmp\*"