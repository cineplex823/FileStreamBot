# PowerShell script to deploy FileStreamBot to Koyeb

Write-Host "FileStreamBot Koyeb Deployment Helper" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host

# Check if koyeb CLI is installed
try {
    $koyebVersion = koyeb version
} catch {
    Write-Host "Koyeb CLI not found. Please install it first." -ForegroundColor Red
    Write-Host "Visit: https://www.koyeb.com/docs/cli/installation" -ForegroundColor Yellow
    exit 1
}

# Check if logged in to Koyeb
Write-Host "Checking Koyeb login status..." -ForegroundColor Yellow
try {
    koyeb whoami | Out-Null
} catch {
    Write-Host "Please login to Koyeb first using: koyeb login" -ForegroundColor Red
    exit 1
}

Write-Host
Write-Host "Creating Koyeb secrets for FileStreamBot..." -ForegroundColor Green

# Prompt for required environment variables
$API_ID = Read-Host "Enter your Telegram API_ID"
$API_HASH = Read-Host "Enter your Telegram API_HASH"
$BOT_TOKEN = Read-Host "Enter your BOT_TOKEN"
$OWNER_ID = Read-Host "Enter your OWNER_ID"
$FLOG_CHANNEL = Read-Host "Enter your FLOG_CHANNEL ID"
$ULOG_CHANNEL = Read-Host "Enter your ULOG_CHANNEL ID"
$DATABASE_URL = Read-Host "Enter your MongoDB DATABASE_URL"

# Create secrets in Koyeb
Write-Host "Creating secrets in Koyeb..." -ForegroundColor Yellow
koyeb secrets create api-id --value "$API_ID"
koyeb secrets create api-hash --value "$API_HASH"
koyeb secrets create bot-token --value "$BOT_TOKEN"
koyeb secrets create owner-id --value "$OWNER_ID"
koyeb secrets create flog-channel --value "$FLOG_CHANNEL"
koyeb secrets create ulog-channel --value "$ULOG_CHANNEL"
koyeb secrets create database-url --value "$DATABASE_URL"

Write-Host
Write-Host "Deploying FileStreamBot to Koyeb..." -ForegroundColor Green
Write-Host "This may take a few minutes..." -ForegroundColor Yellow

# Deploy to Koyeb
koyeb app init filestreambot --git github.com/cineplex823/FileStreamBot --git-branch main --ports 8080:http --routes /:8080 --env API_ID=@api-id --env API_HASH=@api-hash --env BOT_TOKEN=@bot-token --env OWNER_ID=@owner-id --env FLOG_CHANNEL=@flog-channel --env ULOG_CHANNEL=@ulog-channel --env DATABASE_URL=@database-url --env HAS_SSL=True --env PORT=8080 --env BIND_ADDRESS=0.0.0.0

Write-Host
Write-Host "Deployment initiated! Check the status with: koyeb service get filestreambot" -ForegroundColor Green
Write-Host "Once deployed, your bot will be available at the URL provided by Koyeb." -ForegroundColor Cyan
Write-Host
Write-Host "Don't forget to add your bot to both log channels as an admin!" -ForegroundColor Yellow
