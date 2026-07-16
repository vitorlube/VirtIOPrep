#Requires -RunAsAdministrator

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

switch -Wildcard ($Caption) {

    "Microsoft Windows Server 2016*" {$OS="2k16"}
    "Microsoft Windows Server 2019*" {$OS="2k19"}
    "Microsoft Windows Server 2022*" {$OS="2k22"}
    "Microsoft Windows 10*" {$OS="w10"}
    "Microsoft Windows 11*" {$OS="w11"}

    default{
        Write-Host "[ERROR] Unsupported operating system:"
        Write-Host $Caption -ForegroundColor Red
        exit 1
    }
}

Write-Host "Detected OS : $Caption" -ForegroundColor Green
Write-Host "Driver Set : $OS"
Write-Host ""

$Success=0
$Failed=0

foreach($Driver in Get-ChildItem $DriverRoot -Directory){

    $Folder=Join-Path $Driver.FullName "$OS\amd64"

    if(!(Test-Path $Folder)){
        Write-Host "[SKIP] $($Driver.Name)"
        continue
    }

    Write-Host "[INFO] Installing $($Driver.Name)..."

    Get-ChildItem $Folder -Filter *.inf | ForEach-Object{

        pnputil /add-driver $_.FullName /install | Out-Null

        if($LASTEXITCODE -eq 0){

            Write-Host "[ OK ] $($Driver.Name)" -ForegroundColor Green
            $Success++

        }
        else{

            Write-Host "[FAIL] $($Driver.Name)" -ForegroundColor Red
            $Failed++

        }

    }

}

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "Installed : $Success"
Write-Host "Failed    : $Failed"
Write-Host ""

$Expected=@(
"balloon.inf",
"netkvm.inf",
"vioscsi.inf",
"viostor.inf"
)

$Installed=Get-WindowsDriver -Online |
Where-Object ProviderName -match "Red Hat"

$Ok=0

foreach($Driver in $Expected){

    if($Installed.OriginalFileName -match [regex]::Escape($Driver)){

        Write-Host "[ OK ] $Driver" -ForegroundColor Green
        $Ok++

    }
    else{

        Write-Host "[FAIL] $Driver" -ForegroundColor Red

    }

}

Write-Host ""

if($Ok -eq $Expected.Count){

    Write-Host "VirtIO drivers successfully staged." -ForegroundColor Green
    Write-Host "A reboot is recommended before migrating the VM." -ForegroundColor Yellow
    exit 0

}
else{

    Write-Host "Driver validation failed." -ForegroundColor Red
    exit 1

}