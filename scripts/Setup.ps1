# Setup Script for TCGplayer to USPS Converter
Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  TCGplayer to USPS Label Converter - Setup" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

$scriptDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$configPath = Join-Path $scriptDir "config.json"

# Check if config already exists
if (Test-Path $configPath) {
    Write-Host "config.json already exists!" -ForegroundColor Yellow
    $overwrite = Read-Host "Do you want to overwrite it? (y/n)"
    if ($overwrite -ne 'y' -and $overwrite -ne 'Y') {
        Write-Host "Setup cancelled." -ForegroundColor Yellow
        exit
    }
    Write-Host ""
}

Write-Host "Let's set up your sender information:" -ForegroundColor Green
Write-Host ""

# Sender Information
$firstName = Read-Host "First Name"
$lastName = Read-Host "Last Name"
$address = Read-Host "Street Address"
$city = Read-Host "City"
$state = Read-Host "State (2-letter code, e.g., WA)"
$zip = Read-Host "ZIP Code"
$email = Read-Host "Email Address"

Write-Host ""
Write-Host "Package defaults (press Enter to use defaults shown):" -ForegroundColor Green
Write-Host ""

# Package Defaults with defaults
$serviceTypeInput = Read-Host "Service Type [First-Class Mail]"
$serviceType = if ($serviceTypeInput) { $serviceTypeInput } else { "First-Class Mail" }

$packageTypeInput = Read-Host "Package Type [Letter]"
$packageType = if ($packageTypeInput) { $packageTypeInput } else { "Letter" }

$itemDescInput = Read-Host "Item Description [Trading cards]"
$itemDescription = if ($itemDescInput) { $itemDescInput } else { "Trading cards" }

$weightInput = Read-Host "Package Weight in oz [1]"
$weight = if ($weightInput) { $weightInput } else { "1" }

$lengthInput = Read-Host "Package Length in inches [9.5]"
$length = if ($lengthInput) { $lengthInput } else { "9.5" }

$widthInput = Read-Host "Package Width in inches [4.125]"
$width = if ($widthInput) { $widthInput } else { "4.125" }

$heightInput = Read-Host "Package Height in inches [0.25]"
$height = if ($heightInput) { $heightInput } else { "0.25" }

# Create config object
$config = @{
    Sender = @{
        firstName = $firstName
        lastName = $lastName
        address = $address
        city = $city
        state = $state
        zip = $zip
        country = "US"
        email = $email
    }
    Package = @{
        serviceType = $serviceType
        packageType = $packageType
        itemDescription = $itemDescription
        weight = $weight
        length = $length
        width = $width
        height = $height
    }
}

# Save config
$config | ConvertTo-Json -Depth 3 | Out-File $configPath -Encoding UTF8

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Your configuration has been saved to config.json" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now use the converter by:" -ForegroundColor Yellow
Write-Host "  1. Download your TCGplayer export to Downloads folder" -ForegroundColor Gray
Write-Host "  2. Double-click 'Convert TCGplayer to USPS.bat'" -ForegroundColor Gray
Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
