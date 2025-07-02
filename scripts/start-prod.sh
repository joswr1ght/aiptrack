#!/bin/bash

set -e

echo "Starting AIP Track Production Environment..."

# Ensure environment file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found. Please create one from .env.example"
    exit 1
fi

# Validate required environment variables
source .env
required_vars=("DB_ROOT_PASSWORD" "DB_NAME" "DB_USER" "DB_PASSWORD" "JWT_SECRET_KEY" "SECRET_KEY")

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Error: Required environment variable $var is not set"
        exit 1
    fi
done

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Stop any existing containers
echo "🔄 Stopping existing containers..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml down

# Build and start production environment
echo "🚀 Building and starting production services..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build

echo "✅ Production environment started!"
echo "🌐 Application: http://localhost"
echo "🔧 Backend API: http://localhost:3000"

# Show container status
echo "📊 Container Status:"
docker compose -f docker-compose.yml -f docker-compose.prod.yml ps
