#Requires -RunAsAdministrator

Clear-Host

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "           VirtIOPrep v0.1"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$DriverRoot = Join-Path $PSScriptRoot "drivers"

if (!(Test-Path $DriverRoot)) {
    throw "Drivers folder not found."
}

$OS = Get-CimInstance Win32_OperatingSystem

$DriverMap = @{
    "Microsoft Windows Server 2016*" = "2k16"
    "Microsoft Windows Server 2019*" = "2k19"
    "Microsoft Windows Server 2022*" = "2k22"
    "Microsoft Windows 10*"          = "w10"
    "Microsoft Windows 11*"          = "w11"
}

$DriverOS = $null

foreach ($Key in $DriverMap.Keys) {
    if ($OS.Caption -like $Key) {
        $DriverOS = $DriverMap[$Key]
        break
    }
}

if (!$DriverOS) {
    throw "Unsupported operating system: $($OS.Caption)"
}

Write-Host "Detected OS: $($OS.Caption)" -ForegroundColor Green
Write-Host "Using driver set: $DriverOS"
Write-Host ""

$Installed = 0

Get-ChildItem $DriverRoot -Directory | ForEach-Object {

    $Folder = Join-Path $_.FullName "$DriverOS\amd64"

    if (Test-Path $Folder) {

        Write-Host "Installing $($_.Name)..."

        pnputil /add-driver "$Folder\*.inf" /subdirs /install

        $Installed++
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "$Installed driver packages processed."
Write-Host "VM is ready for VirtIO migration."
Write-Host "==========================================" -ForegroundColor Green