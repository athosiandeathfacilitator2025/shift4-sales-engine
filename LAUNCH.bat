@echo off
title Shift4 Sales Engine
cd /d "%~dp0"

echo.
echo  Shift4 Payments Sales Engine
echo  ==============================
echo.

IF NOT EXIST node_modules (
  echo  Installing dependencies...
  npm install
  echo.
)

echo  Starting server at http://localhost:4200
echo  Press Ctrl+C to stop.
echo.

echo  Opening in Google Chrome...
IF EXIST "%PROGRAMFILES%\Google\Chrome\Application\chrome.exe" (
  start "" "%PROGRAMFILES%\Google\Chrome\Application\chrome.exe" http://localhost:4200
) ELSE IF EXIST "%PROGRAMFILES(X86)%\Google\Chrome\Application\chrome.exe" (
  start "" "%PROGRAMFILES(X86)%\Google\Chrome\Application\chrome.exe" http://localhost:4200
) ELSE (
  start "" http://localhost:4200
)
node server.js
