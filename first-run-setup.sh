#!/bin/bash

# First-run setup script for WordPress Docker Development Environment
# This script guides new developers through the initial setup process

echo "==============================================="
echo "WordPress Docker Development Environment Setup"
echo "==============================================="

# Check for Docker and Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed or not in PATH"
    echo "   Please install Docker: https://www.docker.com/get-started"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: Docker Compose is not installed or not in PATH"
    echo "   Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"

# Check for .env file
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found"
    echo "   Creating a default .env file..."
    cat > .env << EOL
# WordPress Environment Variables
WORDPRESS_DB_NAME=wordpress
WORDPRESS_DB_USER=wordpress
WORDPRESS_DB_PASSWORD=wordpress
WORDPRESS_DB_HOST=db:3306

# MySQL Environment Variables
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=wordpress
MYSQL_USER=wordpress
MYSQL_PASSWORD=wordpress

# Website Settings
WORDPRESS_SITE_TITLE="My WordPress Site"
WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=admin
WORDPRESS_ADMIN_EMAIL=admin@example.com

# Development Settings
WORDPRESS_DEBUG=true
WORDPRESS_DEV_MODE=true

# Site URLs
WORDPRESS_SITE_URL=http://localhost:8000
WORDPRESS_HOME=http://localhost:8000
EOL
    echo "✅ Default .env file created"
else
    echo "✅ .env file found, using existing configuration"
fi

# Check for Docker conflicts
if docker ps | grep -q "website-project"; then
    echo "ℹ️ Some Docker containers with the project name are already running."
    read -p "Do you want to stop and remove them? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Stopping existing containers..."
        docker-compose down
    fi
fi

# Check for port conflicts
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️ Warning: Port 8000 is already in use by another process."
    echo "   You may need to modify the port in docker-compose.yml."
fi

if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️ Warning: Port 8080 is already in use by another process."
    echo "   You may need to modify the port in docker-compose.yml."
fi

if lsof -Pi :3306 -sTCP:LISTEN -t >/dev/null ; then
    echo "⚠️ Warning: Port 3306 is already in use by another process."
    echo "   You may need to modify the port in docker-compose.yml."
fi

# Start the environment
echo "Starting Docker containers..."
if ! docker-compose up -d; then
    echo "❌ Error: Failed to start Docker containers"
    echo "   Please check the Docker error message above"
    exit 1
fi

echo "✅ Docker containers started successfully"

# Wait for containers to be ready
echo "Waiting for containers to start up..."
sleep 10

# Check container status
if ! docker-compose ps | grep -q "wordpress.*Up"; then
    echo "❌ Warning: WordPress container might not be running properly"
    echo "Current container status:"
    docker-compose ps
    exit 1
fi

echo "✅ All containers are running"

# Check if WordPress is responding
echo "Checking if WordPress is accessible..."
MAX_RETRIES=10
COUNT=0
until $(curl --output /dev/null --silent --head --fail --max-time 5 http://localhost:8000) || [ $COUNT -eq $MAX_RETRIES ]; do
    printf '.'
    sleep 5
    COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo ""
    echo "❌ Error: WordPress is not responding after $(($MAX_RETRIES * 5)) seconds"
    echo "   Please check Docker logs with: docker-compose logs wordpress"
    exit 1
fi

echo "✅ WordPress is accessible at http://localhost:8000"

# Install WP-CLI if not already installed
echo "Checking WP-CLI installation..."
if ! docker-compose exec wordpress wp --info --allow-root &>/dev/null; then
    echo "ℹ️ Installing WP-CLI in the WordPress container..."
    docker-compose exec wordpress bash -c "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"
    echo "✅ WP-CLI installed successfully"
else
    echo "✅ WP-CLI is already installed"
fi

# Initialize WordPress
echo "Initializing WordPress..."
if ! ./init-wordpress.sh; then
    echo "❌ Error: Failed to initialize WordPress"
    echo "   Please check the error message above"
    exit 1
fi

echo "✅ WordPress initialized successfully"

# Run health check
echo "Running final health check..."
./health-check.sh

echo ""
echo "🎉 Setup completed successfully! 🎉"
echo ""
echo "Your WordPress site is now ready:"
echo "--------------------------------"
echo "WordPress site: http://localhost:8000"
echo "WordPress admin: http://localhost:8000/wp-admin"
echo "  Username: admin"
echo "  Password: admin (or as configured in .env)"
echo ""
echo "phpMyAdmin: http://localhost:8080"
echo "  Username: wordpress"
echo "  Password: wordpress"
echo ""
echo "For more information, see:"
echo "- README.md - General project information"
echo "- DEVELOPMENT.md - Development workflow guide"
echo "- SETUP-GUIDE.md - Detailed setup instructions"
echo ""
