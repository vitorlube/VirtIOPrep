#Requires -RunAsAdministrator

$drivers = Join-Path $PSScriptRoot "drivers"

Write-Host "Installing VirtIO drivers..."

pnputil /add-driver "$drivers\*.inf" /subdirs /install

Write-Host ""
Write-Host "Done!"
