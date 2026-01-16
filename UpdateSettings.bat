@echo off
title Update Package Settings
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\UpdateSettings.ps1"
pause
