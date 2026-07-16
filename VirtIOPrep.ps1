#Requires -RunAsAdministrator

Clear-Host

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "           VirtIOPrep v1.0"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$DriverRoot = Join-Path $PSScriptRoot "drivers"

if (!(Test-Path $DriverRoot)) {
    Write-Host "Drivers folder not found." -ForegroundColor Red
    exit 1
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
    Write-Host "Unsupported OS: $($OS.Caption)" -ForegroundColor Red
    exit 1
}

Write-Host "Detected: $($OS.Caption)"
Write-Host "Driver Set: $DriverOS"
Write-Host ""

$Success = 0
$Failed = 0

Get-ChildItem $DriverRoot -Directory | ForEach-Object {

    $DriverName = $_.Name
    $Folder = Join-Path $_.FullName "$DriverOS\amd64"

    if (!(Test-Path $Folder)) {
        Write-Host "[SKIP] $DriverName (no driver for this OS)" -ForegroundColor Yellow
        return
    }

    $InfFiles = Get-ChildItem $Folder -Filter *.inf

    foreach ($Inf in $InfFiles) {

        Write-Host "[INFO] Installing $DriverName..."

        $Result = pnputil /add-driver $Inf.FullName /install 2>&1

        if ($LASTEXITCODE -eq 0) {

            Write-Host "[ OK ] $DriverName" -ForegroundColor Green
            $Success++

        }
        else {

            Write-Host "[FAIL] $DriverName" -ForegroundColor Red
            $Result
            $Failed++

        }
    }
}

Write-Host ""
Write-Host "=========================================="

Write-Host "Installed : $Success"

Write-Host "Failed    : $Failed"

if ($Failed -eq 0) {

    Write-Host ""
    Write-Host "VM ready for Proxmox migration." -ForegroundColor Green
    exit 0

}
else{

    Write-Host ""
    Write-Host "One or more drivers failed." -ForegroundColor Red
    exit 1

}