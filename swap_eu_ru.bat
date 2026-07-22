@echo off


echo ========================================
echo    Swap folders bin_global and bin_ru
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
powershell -Command "Write-Host '  bin_global <--> bin_ru' -ForegroundColor Green"
powershell -Command "Write-Host '========================================' -ForegroundColor Green"

goto :end

:end
echo.
pause