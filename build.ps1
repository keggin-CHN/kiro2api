# PowerShell build script for kiro2api
# This script builds the Windows executable

Write-Host "Building kiro2api for Windows..." -ForegroundColor Green
Write-Host ""

# Set build parameters
$BinaryName = "kiro2api.exe"
$MainFile = "main.go"

# Set CGO_ENABLED=0 for static binary
$env:CGO_ENABLED = "0"

# Build for Windows
Write-Host "Compiling..." -ForegroundColor Yellow
go build -tags=sonic_no_asm -ldflags="-s -w" -o $BinaryName $MainFile

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Build successful!" -ForegroundColor Green
    Write-Host "Executable: $BinaryName" -ForegroundColor Cyan
    
    # Get file size
    $FileInfo = Get-Item $BinaryName
    $FileSizeMB = [math]::Round($FileInfo.Length / 1MB, 2)
    Write-Host "Size: $FileSizeMB MB" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "To run the application:" -ForegroundColor Yellow
    Write-Host "1. Copy .env.example to .env and configure your settings"
    Write-Host "2. Run: .\$BinaryName"
} else {
    Write-Host ""
    Write-Host "✗ Build failed with error code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}
