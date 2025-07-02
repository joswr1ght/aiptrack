#!/bin/bash

set -e

echo "Starting AIP Track Development Environment..."

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ Created .env file from template. Please update with your values."
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Stop any existing containers
echo "🔄 Stopping existing containers..."
docker compose -f docker-compose.yml -f docker-compose.dev.yml down

# Build and start development environment
echo "🚀 Building and starting development services..."
docker compose -f docker-compose.yml -f docker-compose.dev.yml up --build

echo "✅ Development environment started!"
echo "📱 Frontend: http://localhost:3002"
echo "🔧 Backend API: http://localhost:3001"
echo "🗄️  Database: localhost:3307"
