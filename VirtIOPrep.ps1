#Requires -RunAsAdministrator

Write-Host ""
Write-Host "VirtIOPrep v0.1"
Write-Host ""

$DriverRoot = Join-Path $PSScriptRoot "drivers"

if (!(Test-Path $DriverRoot)) {
    throw "Drivers folder not found."
}

$Build = [Environment]::OSVersion.Version.Build

switch ($Build) {

    {$_ -ge 26100} {$OS="w11";break}
    {$_ -ge 22000} {$OS="w11";break}
    {$_ -ge 20348} {$OS="2k22";break}
    {$_ -ge 17763} {$OS="2k19";break}
    {$_ -ge 14393} {$OS="2k16";break}

    default{
        throw "Unsupported Windows Build: $Build"
    }
}

Write-Host "Detected OS: $OS"
Write-Host ""

$Installed = 0

Get-ChildItem $DriverRoot -Directory | ForEach-Object{

    $Folder = Join-Path $_.FullName "$OS\amd64"

    if(Test-Path $Folder){

        Write-Host "Installing $($_.Name)..."

        pnputil /add-driver "$Folder\*.inf" /subdirs /install | Out-Null

        $Installed++
    }
}

Write-Host ""
Write-Host "$Installed driver packages processed."
Write-Host "Done."