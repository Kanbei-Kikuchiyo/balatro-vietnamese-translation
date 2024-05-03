@echo off
setlocal enabledelayedexpansion

set "colorReset=[0m"
set "resourcesFolder=Balatro_Localization_Resources"

echo ==========================================
echo ==    Balatro Vietnamese Localization   ==
echo == Installation of the VN language pack ==
echo ==        For Balatro 1.0.1f-FULL       ==
echo ==========================================

:: Checking the default Steam installation path (using libraryfolders.vdf)
set "steamLibraryFile=C:\Program Files (x86)\Steam\steamapps\libraryfolders.vdf"
set "balatroPath=C:\Program Files (x86)\Steam\steamapps\Balatro"

:: If it doesn't exist, open the explorer to manually select Balatro.exe
if not exist "!steamLibraryFile!" (
    echo.
    echo Oops, I couldn't find Balatro.exe. Please tell me where to find it

    set "balatroFile="
    set "dialogTitle=Select balatro.exe"
    set "fileFilter=Balatro Executable (balatro.exe) | balatro.exe"

    for /f "delims=" %%I in ('powershell -Command "& { Add-Type -AssemblyName System.Windows.Forms; $dlg = New-Object System.Windows.Forms.OpenFileDialog; $dlg.Filter = '!fileFilter!'; $dlg.Title = '!dialogTitle!'; $dlg.ShowHelp = $true; $dlg.ShowDialog() | Out-Null; $dlg.FileName }"') do set "selectedFile=%%I"

    if defined selectedFile (
        set "balatroFile=!selectedFile!"
        echo Balatro.exe : !balatroFile!
    ) else (
        echo Balatro.exe: File not selected. Installation aborted
        goto :fin
    )
)

:: Set the Folder where Balatro.exe is installed
set "balatroFolder=%~dp0%balatroFile%"
for %%I in ("%balatroFile%") do set "balatroFolder=%%~dpI"

:: Check that the version.dll file already exists in the same directory as Balatro.exe
if not exist "%balatroFolder%version.dll" (
    :: Copy the version.dll file into the same directory as Balatro.exe
    xcopy "%~dp0version.dll" "%balatroFolder%" /y
)

:: Copy the mod files into %appdata%\Roaming\Balatro
set "destinationFolder=%appdata%\Balatro"

:: Check the folder %appdata%\Roaming\Balatro already exist, if not create it
if not exist "%destinationFolder%" (
    mkdir "%destinationFolder%"
)

:: Copy the mod files into %appdata%\Roaming\Balatro
xcopy "%~dp0\Balatro" "!destinationFolder!" /s /e /h /c /y

if %ERRORLEVEL% neq 0 (
    echo Error occurred during copying the mod files. Vietnamese Localization NOT installed
    goto :fin
    pause
)

echo.
echo.
echo Vietnamese Localization successfully installed
echo.
echo.
:fin
pause
