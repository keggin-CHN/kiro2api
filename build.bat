@echo off
REM Windows build script for kiro2api
REM This script builds the Windows executable

echo Building kiro2api for Windows...
echo.

REM Set build parameters
set BINARY_NAME=kiro2api.exe
set MAIN_FILE=main.go

REM Build for Windows (with CGO disabled for static binary)
set CGO_ENABLED=0
go build -tags=nomsgpack -ldflags="-s -w" -o %BINARY_NAME% %MAIN_FILE%

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Build successful!
    echo Executable: %BINARY_NAME%
    echo.
    echo To run the application:
    echo 1. Copy .env.example to .env and configure your settings
    echo 2. Run: %BINARY_NAME%
) else (
    echo.
    echo Build failed with error code %ERRORLEVEL%
    exit /b %ERRORLEVEL%
)
