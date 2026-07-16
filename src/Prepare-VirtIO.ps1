Write-Host ""
Write-Host "===================================="
Write-Host " VirtIOPrep"
Write-Host "===================================="
Write-Host ""

Write-Host "Checking Windows version..."

$os = Get-CimInstance Win32_OperatingSystem

Write-Host "Detected:" $os.Caption

Write-Host ""
Write-Host "Coming soon..."
