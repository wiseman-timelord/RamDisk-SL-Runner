@echo off
setlocal enabledelayedexpansion

:: Initialization - DO NOT EDIT THESE LINES
mode 45,28
cd /d "%~dp0"
color 80
title Ramdisk-SL-Runner

:: Customize for your own preference - EDIT ALL THESE LINES
set "viewer_exe_label=GenesisViewer.exe"
set "viewer_ramdisk_letter=U"
set "ramdisk_software_path=C:\System Files\RamDisk\ramdisk.exe"
set "ramdisk_arguement_mount=/mount:"
set "ramdisk_arguement_unmount=/unmount:"

:: Globals - DO NOT EDIT THESE LINES
set "explorerWindowsOpen=0"
set "explorerPath=C:\"

:: Display Begins
cls
echo =============================================
echo               RamDisk-SL-Runner
echo =============================================
echo.
echo Script Initialized.
echo.
timeout /t 2 /nobreak > NUL

:: Mount RAM Drive - Ensures ramdrive is available and ready.
echo Mounting RAM Drive..
"%ramdisk_software_path%" %ramdisk_arguement_mount%%viewer_ramdisk_letter%
if "!ERRORLEVEL!"=="0" (
    echo ..RAM Drive Mounted.
) else (
    echo ..Failed to Mount RAM Drive!
    pause
    exit /b 1
)
echo Waiting 3 seconds..
timeout /t 3 /nobreak > NUL
echo ..Grace Period Over.
timeout /t 1 /nobreak > NUL

:: Run Viewer Loop - ensures keeping Ramdisk Active, for relog option.
:launchViewer
echo Checking Viewer..
if exist ".\%viewer_exe_label%" (
    echo ..Executing Viewer..
    ".\%viewer_exe_label%"
    echo ..Viewer Exited..
    timeout /t 1 /nobreak > NUL
    goto relog
) else (
    echo ..%viewer_exe_label% Missing!
    echo.
    timeout /t 3 /nobreak > NUL
    goto 2ndGrace
)

:relog 
set /p "relog=..Are You Relogging YN? "
if /i "%relog%"=="y" (
    echo ..Relogging Viewer..
    goto launchViewer
) else (
    echo ..Not relogging..
    goto 2ndGrace
)

:: Ensure all processes have finished, close explorer, then unmount
:2ndGrace
echo Waiting 3 seconds..
timeout /t 3 /nobreak > NUL
echo ..Grace Period Over.
timeout /t 1 /nobreak > NUL
echo Checking Explorer..
for /f "delims=" %%i in ('powershell -Command "$shell = New-Object -ComObject shell.application; $shell.Windows() | Where-Object { $_.HWND -ne 0 -and $_.FullName -match 'explorer\.exe$' } | ForEach-Object { $location = ''; try { $location = $_.Document.Folder.Self.Path } catch {}; if ($location) { Write-Output $location; break; } }"') do set "explorerPath=%%i"
if not "!explorerPath!"=="C:\" (
    set "explorerWindowsOpen=1"
    powershell -Command "Get-Process explorer | Where-Object { $_.MainWindowHandle -ne 0 } | ForEach-Object { Stop-Process -Id $_.Id }"
    echo ..Explorer Closed.
) else (
    echo ..No Explorers Open.
)
timeout /t 1 /nobreak > NUL
echo Unmounting RamDrive..
"%ramdisk_software_path%" %ramdisk_arguement_unmount%%viewer_ramdisk_letter%
if "!ERRORLEVEL!"=="0" (
    echo ..RamDrive Unmounted..
) else (
    echo ..Failed To Unmount!
)
timeout /t 3 /nobreak > NUL

:: Outro - Unmount complete, restoring explorer, then exiting.
if !explorerWindowsOpen! equ 1 (
    echo Re-Opening Explorer..
    powershell -Command "$path = '!explorerPath!'.Replace('file:///', '').Replace('/', '\'); $path = [System.Uri]::UnescapeDataString($path); if (Test-Path \"$path\") { Start-Process 'explorer.exe' -ArgumentList \"/n,/e,$path\" } else { Start-Process 'explorer.exe' }"
    echo ..Explorer Opened.
)
echo.
timeout /t 1 /nobreak > NUL
echo Complete, Exiting...
timeout /t 5 /nobreak > NUL
endlocal
exit
