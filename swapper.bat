@echo off
title Swap folders bin_global ^<-> bin_ru
cd /d "%~dp0"

echo ========================================
echo   Swap folders bin_global and bin_ru
echo ========================================
echo.
echo Current directory: %CD%
echo.

REM Check if both folders exist
if not exist "bin_global\" (
    powershell -Command "Write-Host '[ERROR] Folder bin_global not found!' -ForegroundColor Red"
    powershell -Command "Write-Host 'Both folders are required for the script to work.' -ForegroundColor Yellow"
    goto :end
)

if not exist "bin_ru\" (
    powershell -Command "Write-Host '[ERROR] Folder bin_ru not found!' -ForegroundColor Red"
    powershell -Command "Write-Host 'Both folders are required for the script to work.' -ForegroundColor Yellow"
    goto :end
)

REM Check if version file exists
if not exist "bin_ru\version" (
    powershell -Command "Write-Host '[ERROR] File bin_ru\version not found!' -ForegroundColor Red"
    powershell -Command "Write-Host 'The version file is required to verify compatibility.' -ForegroundColor Yellow"
    goto :end
)

REM Check version file content
set "expected_version=aedae66e-b13a-4fc6-9cb1-fb79024b1462"
set "version_match=0"

REM Read the version file and check for the expected string
findstr /C:"%expected_version%" "bin_ru\version" >nul 2>&1
if %errorlevel% equ 0 (
    set "version_match=1"
)

if "%version_match%"=="0" (
    powershell -Command "Write-Host '[ERROR] Version mismatch!' -ForegroundColor Red"
    powershell -Command "Write-Host 'Expected version string not found in bin_ru\version' -ForegroundColor Red"
    powershell -Command "Write-Host 'Required: %expected_version%' -ForegroundColor Yellow"
    echo.
    echo Current content of bin_ru\version:
    type "bin_ru\version"
    echo.
    powershell -Command "Write-Host 'Folders will NOT be swapped.' -ForegroundColor Yellow"
    goto :end
)

powershell -Command "Write-Host '[OK] Version check passed.' -ForegroundColor Green"
powershell -Command "Write-Host '[OK] Both folders found.' -ForegroundColor Green"
powershell -Command "Write-Host '[>>] Starting swap...' -ForegroundColor Cyan"

REM Check if temporary folder exists from previous failed run
if exist "bin_temp_swap\" (
    powershell -Command "Write-Host '[ERROR] Temporary folder bin_temp_swap found from previous run!' -ForegroundColor Red"
    powershell -Command "Write-Host 'Previous swap may have failed.' -ForegroundColor Yellow"
    powershell -Command "Write-Host 'Check folders manually and delete bin_temp_swap.' -ForegroundColor Yellow"
    goto :end
)

REM Swap folders using temporary name
rename "bin_global" "bin_temp_swap"
if errorlevel 1 (
    powershell -Command "Write-Host '[ERROR] Failed to rename bin_global' -ForegroundColor Red"
    goto :end
)

rename "bin_ru" "bin_global"
if errorlevel 1 (
    powershell -Command "Write-Host '[ERROR] Failed to rename bin_ru' -ForegroundColor Red"
    powershell -Command "Write-Host '[RECOVERY] Restoring bin_global...' -ForegroundColor Yellow"
    rename "bin_temp_swap" "bin_global"
    goto :end
)

rename "bin_temp_swap" "bin_ru"
if errorlevel 1 (
    powershell -Command "Write-Host '[ERROR] Failed to complete swap!' -ForegroundColor Red"
    powershell -Command "Write-Host '[WARNING] Check folder names manually!' -ForegroundColor Yellow"
    goto :end
)

powershell -Command "Write-Host ''"
powershell -Command "Write-Host '========================================' -ForegroundColor Green"
powershell -Command "Write-Host '  [SUCCESS] Folders swapped successfully!' -ForegroundColor Green"
powershell -Command "Write-Host '  bin_global and bin_ru' -ForegroundColor Green"
powershell -Command "Write-Host '========================================' -ForegroundColor Green"

goto :end

:end
echo.
pause