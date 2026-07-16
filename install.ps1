#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$Temp = Join-Path $env:TEMP "VirtIOPrep"

Remove-Item $Temp -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $Temp | Out-Null

Write-Host "Downloading VirtIOPrep..."

Invoke-WebRequest `
"https://github.com/vitorlube/VirtIOPrep/releases/latest/download/VirtIOPrep.ps1" `
-OutFile "$Temp\VirtIOPrep.ps1"

Write-Host "Downloading drivers..."

Invoke-WebRequest `
"https://github.com/vitorlube/VirtIOPrep/releases/latest/download/drivers.zip" `
-OutFile "$Temp\drivers.zip"

Write-Host "Extracting..."

Expand-Archive `
"$Temp\drivers.zip" `
"$Temp" `
-Force

Write-Host "Running VirtIOPrep..."

Push-Location $Temp

try {
    & ".\VirtIOPrep.ps1"
}
finally {
    Pop-Location
    Remove-Item $Temp -Recurse -Force -ErrorAction SilentlyContinue
}