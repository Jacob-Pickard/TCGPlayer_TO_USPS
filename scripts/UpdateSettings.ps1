# Update Package Settings
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Update Package Default Settings" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$scriptDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$configPath = Join-Path $scriptDir "config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "Error: config.json not found!" -ForegroundColor Red
    Write-Host "Please run Setup.bat first to create your configuration." -ForegroundColor Yellow
    exit
}

# Load existing config
$config = Get-Content $configPath | ConvertFrom-Json

Write-Host "Current Package Defaults:" -ForegroundColor Yellow
Write-Host "  Service Type: $($config.Package.serviceType)" -ForegroundColor Gray
Write-Host "  Package Type: $($config.Package.packageType)" -ForegroundColor Gray
Write-Host "  Item Description: $($config.Package.itemDescription)" -ForegroundColor Gray
Write-Host "  Weight: $($config.Package.weight) oz" -ForegroundColor Gray
Write-Host "  Dimensions: $($config.Package.length) x $($config.Package.width) x $($config.Package.height) inches" -ForegroundColor Gray
Write-Host ""

$update = Read-Host "Update these settings? (y/n)"
if ($update -ne 'y' -and $update -ne 'Y') {
    Write-Host "No changes made." -ForegroundColor Yellow
    exit
}

Write-Host ""
Write-Host "Enter new values (press Enter to keep current):" -ForegroundColor Green
Write-Host ""

# Service Type
$serviceTypeInput = Read-Host "Service Type [$($config.Package.serviceType)]"
if ($serviceTypeInput) { $config.Package.serviceType = $serviceTypeInput }

# Package Type
$packageTypeInput = Read-Host "Package Type [$($config.Package.packageType)]"
if ($packageTypeInput) { $config.Package.packageType = $packageTypeInput }

# Item Description
$itemDescInput = Read-Host "Item Description [$($config.Package.itemDescription)]"
if ($itemDescInput) { $config.Package.itemDescription = $itemDescInput }

# Weight
$weightInput = Read-Host "Package Weight (oz) [$($config.Package.weight)]"
if ($weightInput) { $config.Package.weight = $weightInput }

# Length
$lengthInput = Read-Host "Package Length (inches) [$($config.Package.length)]"
if ($lengthInput) { $config.Package.length = $lengthInput }

# Width
$widthInput = Read-Host "Package Width (inches) [$($config.Package.width)]"
if ($widthInput) { $config.Package.width = $widthInput }

# Height
$heightInput = Read-Host "Package Height (inches) [$($config.Package.height)]"
if ($heightInput) { $config.Package.height = $heightInput }

# Save updated config
$config | ConvertTo-Json -Depth 3 | Out-File $configPath -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  Settings Updated!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "New Package Defaults:" -ForegroundColor Cyan
Write-Host "  Service Type: $($config.Package.serviceType)" -ForegroundColor Gray
Write-Host "  Package Type: $($config.Package.packageType)" -ForegroundColor Gray
Write-Host "  Item Description: $($config.Package.itemDescription)" -ForegroundColor Gray
Write-Host "  Weight: $($config.Package.weight) oz" -ForegroundColor Gray
Write-Host "  Dimensions: $($config.Package.length) x $($config.Package.width) x $($config.Package.height) inches" -ForegroundColor Gray
Write-Host ""
Write-Host "These defaults will be used for all future conversions." -ForegroundColor Yellow
Write-Host "You can still customize per-batch when running the converter." -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
