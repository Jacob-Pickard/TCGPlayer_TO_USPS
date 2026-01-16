# TCGplayer to USPS Label Template Converter
param(
    [Parameter(Mandatory=$false)]
    [string]$InputFile,
    
    [Parameter(Mandatory=$false)]
    [string]$OutputFile
)

# Load configuration
$scriptDir = Split-Path -Parent (Split-Path -Parent $PSCommandPath)
$configPath = Join-Path $scriptDir "config.json"

if (-not (Test-Path $configPath)) {
    Write-Host "Error: config.json not found!" -ForegroundColor Red
    Write-Host "Please run Setup.bat first or copy config.example.json to config.json" -ForegroundColor Yellow
    exit
}

$config = Get-Content $configPath | ConvertFrom-Json

# Load settings from config
$senderFirstName = $config.Sender.firstName
$senderLastName = $config.Sender.lastName
$senderAddress = $config.Sender.address
$senderCity = $config.Sender.city
$senderState = $config.Sender.state
$senderZip = $config.Sender.zip
$senderCountry = $config.Sender.country
$senderEmail = $config.Sender.email

$serviceType = $config.Package.serviceType
$packageType = $config.Package.packageType
$itemDescription = $config.Package.itemDescription
$packageWeight = $config.Package.weight
$countryOfOrigin = "US"
$packageLength = $config.Package.length
$packageWidth = $config.Package.width
$packageHeight = $config.Package.height
$insuredValue = ""

# Setup directories
$outputFolder = Join-Path $scriptDir "Output"
$archiveFolder = Join-Path $scriptDir "TCGplayer_Archive"

# Create folders if they do not exist
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory -Force | Out-Null
}
if (-not (Test-Path $archiveFolder)) {
    New-Item -Path $archiveFolder -ItemType Directory -Force | Out-Null
}

# If no input file specified, find newest TCGplayer export
$deleteOriginal = $false
if (-not $InputFile) {
    $downloads = [Environment]::GetFolderPath("UserProfile") + "\Downloads"
    $tcgFiles = Get-ChildItem -Path $downloads -Filter "TCGplayer_ShippingExport_*.csv" | Sort-Object LastWriteTime -Descending
    
    if ($tcgFiles.Count -eq 0) {
        Write-Host "No TCGplayer export files found in Downloads folder." -ForegroundColor Red
        Write-Host "Usage: .\ConvertToUSPS.ps1 -InputFile <path>" -ForegroundColor Yellow
        exit
    }
    
    $originalFile = $tcgFiles[0].FullName
    $InputFile = $originalFile
    $deleteOriginal = $true
    Write-Host "Found: $($tcgFiles[0].Name)" -ForegroundColor Green
}

if (-not (Test-Path $InputFile)) {
    Write-Host "Error: File not found: $InputFile" -ForegroundColor Red
    exit
}

# Archive the TCGplayer file
$archiveFileName = Split-Path $InputFile -Leaf
$archivedFile = Join-Path $archiveFolder $archiveFileName
Copy-Item -Path $InputFile -Destination $archivedFile -Force
Write-Host "Archived to: $archiveFolder" -ForegroundColor Gray

Write-Host ""
Write-Host "Converting to USPS format..." -ForegroundColor Cyan

# Read and process
$tcgOrders = Import-Csv -Path $InputFile

if ($tcgOrders.Count -eq 0) {
    Write-Host "Error: No orders found" -ForegroundColor Red
    exit
}

# Ask if user wants to customize settings
Write-Host ""
$customize = Read-Host "Customize package settings for this batch? (y/n) [n]"
if ($customize -eq 'y' -or $customize -eq 'Y') {
    Write-Host ""
    Write-Host "Package Settings (press Enter to use defaults):" -ForegroundColor Yellow
    Write-Host ""
    
    $serviceInput = Read-Host "Service Type [$serviceType]"
    if ($serviceInput) { $serviceType = $serviceInput }
    
    $packageTypeInput = Read-Host "Package Type [$packageType]"
    if ($packageTypeInput) { $packageType = $packageTypeInput }
    
    $weightInput = Read-Host "Package Weight (oz) [$packageWeight]"
    if ($weightInput) { $packageWeight = $weightInput }
    
    $lengthInput = Read-Host "Length (inches) [$packageLength]"
    if ($lengthInput) { $packageLength = $lengthInput }
    
    $widthInput = Read-Host "Width (inches) [$packageWidth]"
    if ($widthInput) { $packageWidth = $widthInput }
    
    $heightInput = Read-Host "Height (inches) [$packageHeight]"
    if ($heightInput) { $packageHeight = $heightInput }
    
    $insuredInput = Read-Host "Insured Value (leave blank for none) []"
    if ($insuredInput) { $insuredValue = $insuredInput }
    
    $descInput = Read-Host "Item Description [$itemDescription]"
    if ($descInput) { $itemDescription = $descInput }
    
    Write-Host ""
}

# Generate output filename with order count
if (-not $OutputFile) {
    $dateStr = Get-Date -Format "MMMdd"
    $orderCount = $tcgOrders.Count
    $orderText = if ($orderCount -eq 1) { "order" } else { "orders" }
    $OutputFile = Join-Path $outputFolder "USPS_Labels_${orderCount}${orderText}_${dateStr}.csv"
}

Write-Host "Processing $($tcgOrders.Count) orders..." -ForegroundColor Cyan

$uspsLabels = @()

foreach ($order in $tcgOrders) {
    # Use order value if no custom insured value provided
    $currentInsuredValue = if ($insuredValue) { $insuredValue } else { "" }
    
    $uspsLabel = [PSCustomObject]@{
        "Reference ID" = $order."Order #"
        "Reference ID 2" = ""
        "Shipping Date" = $order."Order Date"
        "Item Description" = $itemDescription
        "Item Quantity" = $order."Item Count"
        "Item Weight (lb)" = ""
        "Item Weight (oz)" = $packageWeight
        "Item Value" = $order."Value Of Products"
        "HS Tariff #" = ""
        "Country of Origin" = $countryOfOrigin
        "Sender First Name" = $senderFirstName
        "Sender Middle Initial" = ""
        "Sender Last Name" = $senderLastName
        "Sender Company/Org Name" = ""
        "Sender Address Line 1" = $senderAddress
        "Sender Address Line 2" = ""
        "Sender Address Line 3" = ""
        "Sender Address Town/City" = $senderCity
        "Sender State" = $senderState
        "Sender Country" = $senderCountry
        "Sender ZIP Code" = $senderZip
        "Sender Urbanization Code" = ""
        "Ship From Another ZIP Code" = ""
        "Sender Email" = $senderEmail
        "Sender Cell Phone" = ""
        "Recipient Country" = $order.Country
        "Recipient First Name" = $order.FirstName
        "Recipient Middle Initial" = ""
        "Recipient Last Name" = $order.LastName
        "Recipient Company/Org Name" = ""
        "Recipient Address Line 1" = $order.Address1
        "Recipient Address Line 2" = $order.Address2
        "Recipient Address Line 3" = ""
        "Recipient Address Town/City" = $order.City
        "Recipient Province" = ""
        "Recipient State" = $order.State
        "Recipient ZIP Code" = $order.PostalCode
        "Recipient Urbanization Code" = ""
        "Recipient Phone" = ""
        "Recipient Email" = ""
        "Service Type" = $serviceType
        "Package Type" = $packageType
        "Package Weight (lb)" = ""
        "Package Weight (oz)" = $packageWeight
        "Length" = $packageLength
        "Width" = $packageWidth
        "Height" = $packageHeight
        "Girth" = ""
        "Insured Value" = $currentInsuredValue
        "Contents" = ""
        "Contents Description" = ""
        "Package Comments" = ""
        "Customs Form Reference #" = ""
        "License #" = ""
        "Certificate #" = ""
        "Invoice #" = ""
    }
    
    $uspsLabels += $uspsLabel
    Write-Host "  Converted: $($order."Order #") - $($order.FirstName) $($order.LastName)" -ForegroundColor Green
}

# Export
$uspsLabels | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8

# Delete original from Downloads if it was auto-found
if ($deleteOriginal) {
    Remove-Item -Path $originalFile -Force
    Write-Host ""
    Write-Host "Deleted original from Downloads" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Conversion complete!" -ForegroundColor Green
Write-Host "USPS Labels: $OutputFile" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ready to import into USPS" -ForegroundColor Yellow
