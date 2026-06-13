@echo off
setlocal
set "SCRIPT=%~dp0REPAIR_SAVE_EXISTING_TIGHT_SNAP_RULE_20260613.ps1"

if not exist "%SCRIPT%" (
  echo Missing script next to this runner:
  echo %SCRIPT%
  pause
  exit /b 1
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT%"
exit /b %ERRORLEVEL%
