# Electron Quick Build Script (PowerShell .ps1) - Self-Contained with Policy Bypass
# Save as build.ps1 in your project folder.
# Run in VS Code terminal: .\build.ps1
# This version auto-handles execution policy by relaunching with Bypass if needed.

# Check current execution policy
$currentPolicy = Get-ExecutionPolicy -Scope CurrentUser
if ($currentPolicy -eq "Restricted" -or $currentPolicy -eq "AllSigned") {
    Write-Host "[INFO] Execution policy is restrictive ($currentPolicy). Relaunching with Bypass..." -ForegroundColor Yellow
    $scriptPath = $PSCommandPath
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Wait -NoNewWindow
    exit $LASTEXITCODE
}

# If we reach here, policy allows running - proceed with build
Write-Host "[INFO] Execution policy OK. Starting build..." -ForegroundColor Green

Write-Host "[INFO] Installing dependencies (skip if already done)..." -ForegroundColor Green
npm install

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] npm install failed. Check output above." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit $LASTEXITCODE
}

Write-Host "[INFO] Dependencies ready. Running build (npm run dist) - this will take 5-10 min on first run..." -ForegroundColor Green
npm run dist

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Build failed. Check output above." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit $LASTEXITCODE
}

Write-Host "[SUCCESS] Build complete! .exe in dist\ folder." -ForegroundColor Green
$test = Read-Host "Test with npm start? (y/n)"
if ($test -eq "y" -or $test -eq "Y") {
    Write-Host "[INFO] Starting dev mode..." -ForegroundColor Green
    npm start
}

Write-Host "[INFO] Done. Press Enter to exit."
Read-Host