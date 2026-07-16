#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$Repo = "https://github.com/vitorlube/VirtIOPrep/releases/latest/download"

$Temp = Join-Path $env:TEMP "VirtIOPrep"

Remove-Item $Temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory $Temp | Out-Null

Write-Host ""
Write-Host "Downloading VirtIOPrep..." -ForegroundColor Cyan

Invoke-WebRequest "$Repo/VirtIOPrep.ps1" -OutFile "$Temp\VirtIOPrep.ps1"

Write-Host "Downloading drivers..." -ForegroundColor Cyan

Invoke-WebRequest "$Repo/drivers.zip" -OutFile "$Temp\drivers.zip"

Write-Host "Extracting..." -ForegroundColor Cyan

Expand-Archive "$Temp\drivers.zip" "$Temp" -Force

Write-Host "Running VirtIOPrep..." -ForegroundColor Green

& "$Temp\VirtIOPrep.ps1"

Write-Host ""

Write-Host "Cleaning temporary files..." -ForegroundColor Yellow

Remove-Item $Temp -Recurse -Force