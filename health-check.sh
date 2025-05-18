#!/bin/bash

# Health check script for WordPress Docker environment
echo "Checking WordPress Docker environment..."

# Function to check container status
check_container() {
    local container_name="website-project-$1"
    local status=$(docker ps -q -f name=$container_name)
    
    if [ -z "$status" ]; then
        echo "❌ $1 container is not running"
        return 1
    else
        echo "✅ $1 container is running"
        return 0
    fi
}

# Check all containers
db_status=0
wordpress_status=0
phpmyadmin_status=0

check_container "db" || db_status=1
check_container "wordpress" || wordpress_status=1
check_container "phpmyadmin" || phpmyadmin_status=1

# Check if WordPress is accessible
echo "Checking WordPress site accessibility..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000)

if [ "$response" == "200" ] || [ "$response" == "302" ]; then
    echo "✅ WordPress site is accessible at http://localhost:8000"
    wp_accessible=0
else
    echo "❌ WordPress site is not accessible at http://localhost:8000"
    wp_accessible=1
fi

# Check if phpMyAdmin is accessible
echo "Checking phpMyAdmin accessibility..."
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)

if [ "$response" == "200" ] || [ "$response" == "302" ]; then
    echo "✅ phpMyAdmin is accessible at http://localhost:8080"
    pma_accessible=0
else
    echo "❌ phpMyAdmin is not accessible at http://localhost:8080"
    pma_accessible=1
fi

# Overall status
echo ""
echo "Health Check Summary"
echo "-------------------"

if [ $db_status -eq 0 ] && [ $wordpress_status -eq 0 ] && [ $phpmyadmin_status -eq 0 ] && [ $wp_accessible -eq 0 ] && [ $pma_accessible -eq 0 ]; then
    echo "✅ All systems are operational"
    exit 0
else
    echo "❌ Some issues were detected"
    exit 1
fi
