#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Clear-Host

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "              VirtIOPrep v1.0"
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

$DriverRoot = Join-Path $PSScriptRoot "drivers"

if (!(Test-Path $DriverRoot)) {
    Write-Host "[ERROR] Drivers folder not found." -ForegroundColor Red
    exit 1
}

$Caption = (Get-CimInstance Win32_OperatingSystem).Caption

if ($Caption.Contains("Server 2016")) {
    $OS = "2k16"
}
elseif ($Caption.Contains("Server 2019")) {
    $OS = "2k19"
}
elseif ($Caption.Contains("Server 2022")) {
    $OS = "2k22"
}
elseif ($Caption.Contains("Server 2025")) {
    $OS = "2k22"
}
elseif ($Caption.Contains("Windows 10")) {
    $OS = "w10"
}
elseif ($Caption.Contains("Windows 11")) {
    $OS = "w11"
}
else {
    Write-Host "[ERROR] Unsupported operating system:" -ForegroundColor Red
    Write-Host $Caption
    exit 1
}

Write-Host "Detected OS : $Caption" -ForegroundColor Green
Write-Host "Driver Set  : $OS"
Write-Host ""

$InstalledCount = 0
$FailedCount = 0

foreach ($Driver in Get-ChildItem $DriverRoot -Directory) {

    $Folder = Join-Path $Driver.FullName "$OS\amd64"

    if (!(Test-Path $Folder)) {
        Write-Host "[SKIP] $($Driver.Name)" -ForegroundColor Yellow
        continue
    }

    Write-Host "[INFO] Installing $($Driver.Name)..."

    foreach ($Inf in Get-ChildItem $Folder -Filter *.inf) {

        pnputil /add-driver $Inf.FullName | Out-Null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "[ OK ] $($Driver.Name)" -ForegroundColor Green
            $InstalledCount++
        }
        else {
            Write-Host "[FAIL] $($Driver.Name)" -ForegroundColor Red
            $FailedCount++
        }
    }
}

Write-Host ""
Write-Host "Validating installed drivers..."
Write-Host ""

$ExpectedDrivers = @(
    "balloon.inf",
    "netkvm.inf",
    "qemupciserial.inf",
    "vioscsi.inf",
    "viostor.inf"
)

$InstalledDrivers = Get-WindowsDriver -Online |
    Where-Object ProviderName -match "Red Hat"

$Validated = 0

foreach ($Driver in $ExpectedDrivers) {

    $Match = $InstalledDrivers |
        Where-Object { $_.OriginalFileName -like "*$Driver" }

    if ($Match) {
        Write-Host ("[ OK ] {0,-20} {1}" -f $Driver.Replace(".inf",""), $Match.Version) -ForegroundColor Green
        $Validated++
    }
    else {
        Write-Host ("[FAIL] {0}" -f $Driver.Replace(".inf","")) -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ("Installed Packages : {0}" -f $InstalledCount)
Write-Host ("Failed Packages    : {0}" -f $FailedCount)
Write-Host ("Validated Drivers  : {0}/{1}" -f $Validated, $ExpectedDrivers.Count)
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

if ($Validated -eq $ExpectedDrivers.Count -and $FailedCount -eq 0) {
    Write-Host "SUCCESS: VM is ready for VMware -> Proxmox migration." -ForegroundColor Green
    exit 0
}
else {
    Write-Host "ERROR: Driver validation failed." -ForegroundColor Red
    exit 1
}