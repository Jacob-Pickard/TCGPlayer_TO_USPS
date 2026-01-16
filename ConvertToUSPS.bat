@echo off
title TCGplayer to USPS Converter
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\ConvertToUSPS.ps1"
pause
