#Requires -RunAsAdministrator

$Version = "v0.1.0"

$Temp = "$env:TEMP\VirtIOPrep"
$Zip = "$Temp\drivers.zip"

$Repo = "https://github.com/vitorlube/VirtIOPrep/releases/download/$Version/drivers.zip"

Write-Host ""
Write-Host "=== VirtIOPrep ==="
Write-Host ""

New-Item -ItemType Directory -Force -Path $Temp | Out-Null

Write-Host "Downloading drivers..."
Invoke-WebRequest $Repo -OutFile $Zip

Write-Host "Extracting..."
Expand-Archive $Zip $Temp -Force

Write-Host "Installing drivers..."
pnputil /add-driver "$Temp\drivers\*.inf" /subdirs /install

Write-Host "Cleaning..."
Remove-Item $Temp -Recurse -Force

Write-Host ""
Write-Host "Done!"
Write-Host "Your VM is ready for VirtIO migration."
