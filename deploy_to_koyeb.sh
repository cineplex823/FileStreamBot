#!/bin/bash

# Script to deploy FileStreamBot to Koyeb

echo "FileStreamBot Koyeb Deployment Helper"
echo "===================================="
echo

# Check if koyeb CLI is installed
if ! command -v koyeb &> /dev/null; then
    echo "Koyeb CLI not found. Please install it first."
    echo "Visit: https://www.koyeb.com/docs/cli/installation"
    exit 1
fi

# Check if logged in to Koyeb
echo "Checking Koyeb login status..."
koyeb whoami || {
    echo "Please login to Koyeb first using: koyeb login"
    exit 1
}

echo
echo "Creating Koyeb secrets for FileStreamBot..."

# Prompt for required environment variables
read -p "Enter your Telegram API_ID: " API_ID
read -p "Enter your Telegram API_HASH: " API_HASH
read -p "Enter your BOT_TOKEN: " BOT_TOKEN
read -p "Enter your OWNER_ID: " OWNER_ID
read -p "Enter your FLOG_CHANNEL ID: " FLOG_CHANNEL
read -p "Enter your ULOG_CHANNEL ID: " ULOG_CHANNEL
read -p "Enter your MongoDB DATABASE_URL: " DATABASE_URL

# Create secrets in Koyeb
echo "Creating secrets in Koyeb..."
koyeb secrets create api-id --value "$API_ID"
koyeb secrets create api-hash --value "$API_HASH"
koyeb secrets create bot-token --value "$BOT_TOKEN"
koyeb secrets create owner-id --value "$OWNER_ID"
koyeb secrets create flog-channel --value "$FLOG_CHANNEL"
koyeb secrets create ulog-channel --value "$ULOG_CHANNEL"
koyeb secrets create database-url --value "$DATABASE_URL"

echo
echo "Deploying FileStreamBot to Koyeb..."
echo "This may take a few minutes..."

# Deploy to Koyeb
koyeb app init filestreambot --git github.com/cineplex823/FileStreamBot --git-branch main --ports 8080:http --routes /:8080 --env API_ID=@api-id --env API_HASH=@api-hash --env BOT_TOKEN=@bot-token --env OWNER_ID=@owner-id --env FLOG_CHANNEL=@flog-channel --env ULOG_CHANNEL=@ulog-channel --env DATABASE_URL=@database-url --env HAS_SSL=True --env PORT=8080 --env BIND_ADDRESS=0.0.0.0

echo
echo "Deployment initiated! Check the status with: koyeb service get filestreambot"
echo "Once deployed, your bot will be available at the URL provided by Koyeb."
echo
echo "Don't forget to add your bot to both log channels as an admin!"
