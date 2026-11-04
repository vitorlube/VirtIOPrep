#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

# Forca TLS 1.2 (sem bor, nao derruba protocolos ja habilitados). Sem isto o
# download do GitHub falha com "Could not create SSL/TLS secure channel" no
# Windows Server 2016/2019 (PowerShell 5.1 / .NET usa TLS 1.0 por padrao).
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

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