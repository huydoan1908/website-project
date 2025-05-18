#!/bin/bash

# WordPress initialization script
# This script will initialize WordPress with default settings after the containers are up

# Function to read variables from .env file
read_env_var() {
    local var_name=$1
    local default_value=$2
    local value=""
    
    if [ -f .env ]; then
        # Extract value using sed, handling quotes and comments
        value=$(grep -E "^$var_name=" .env | sed -E 's/^[^=]+=//; s/^"//; s/"$//; s/^'\''//; s/'\''$//')
    fi
    
    # Return default if empty
    if [ -z "$value" ]; then
        echo "$default_value"
    else
        echo "$value"
    fi
}

# Check if docker and docker-compose are installed
if ! command -v docker &> /dev/null; then
    echo "Error: docker is not installed or not in PATH"
    echo "Please install Docker: https://www.docker.com/get-started"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose is not installed or not in PATH"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Check if containers are running
if ! docker ps | grep -q "wordpress"; then
    echo "WordPress container is not running."
    echo "Starting containers..."
    docker-compose up -d
    
    # Wait for containers to start
    echo "Waiting for containers to start up..."
    sleep 10
fi

echo "Initializing WordPress installation..."

# Load environment variables from .env file
echo "Loading configuration..."
WORDPRESS_SITE_URL=$(read_env_var "WORDPRESS_SITE_URL" "http://localhost:8000")
WORDPRESS_SITE_TITLE=$(read_env_var "WORDPRESS_SITE_TITLE" "My WordPress Site")
WORDPRESS_ADMIN_USER=$(read_env_var "WORDPRESS_ADMIN_USER" "admin")
WORDPRESS_ADMIN_PASSWORD=$(read_env_var "WORDPRESS_ADMIN_PASSWORD" "admin")
WORDPRESS_ADMIN_EMAIL=$(read_env_var "WORDPRESS_ADMIN_EMAIL" "admin@example.com")

# Display the values being used (except password)
echo "Using the following configuration:"
echo "  Site URL: $WORDPRESS_SITE_URL"
echo "  Site Title: $WORDPRESS_SITE_TITLE"
echo "  Admin User: $WORDPRESS_ADMIN_USER"
echo "  Admin Email: $WORDPRESS_ADMIN_EMAIL"

# Wait for WordPress to be ready
echo "Waiting for WordPress to be ready..."
MAX_RETRIES=30
COUNT=0
until $(curl --output /dev/null --silent --head --fail --max-time 5 http://localhost:8000) || [ $COUNT -eq $MAX_RETRIES ]; do
    printf '.'
    sleep 5
    COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo ""
    echo "Error: WordPress is not responding after $(($MAX_RETRIES * 5)) seconds"
    echo "Please check your Docker containers status:"
    docker-compose ps
    exit 1
fi
echo " WordPress is ready!"

# Check if WordPress is already installed
echo "Checking WordPress installation status..."
if docker-compose exec wordpress bash -c "wp core is-installed --allow-root" &>/dev/null; then
    echo "WordPress is already installed."
else
    echo "Installing WordPress..."

    # Install WordPress with error handling
    if ! docker-compose exec wordpress bash -c "wp core install --url=\"$WORDPRESS_SITE_URL\" --title=\"$WORDPRESS_SITE_TITLE\" --admin_user=\"$WORDPRESS_ADMIN_USER\" --admin_password=\"$WORDPRESS_ADMIN_PASSWORD\" --admin_email=\"$WORDPRESS_ADMIN_EMAIL\" --skip-email --allow-root"; then
        echo "Error: WordPress installation failed"
        echo "Please check the Docker logs for more information:"
        echo "docker-compose logs wordpress"
        exit 1
    fi

    # Configure WordPress settings
    echo "Configuring WordPress settings..."
    docker-compose exec wordpress bash -c "wp option update blogdescription 'Just another WordPress site' --allow-root" || echo "Warning: Could not update blog description"
    docker-compose exec wordpress bash -c "wp option update timezone_string 'America/New_York' --allow-root" || echo "Warning: Could not update timezone"
    docker-compose exec wordpress bash -c "wp option update permalink_structure '/%postname%/' --allow-root" || echo "Warning: Could not update permalink structure"

    # Activate custom theme
    echo "Activating custom theme..."
    if ! docker-compose exec wordpress bash -c "wp theme is-installed custom-theme --allow-root"; then
        echo "Custom theme is not installed. Make sure it exists in wp-content/themes/custom-theme/"
        # List available themes for debugging
        echo "Available themes:"
        docker-compose exec wordpress bash -c "wp theme list --allow-root"
    else
        docker-compose exec wordpress bash -c "wp theme activate custom-theme --allow-root" || echo "Warning: Could not activate custom theme"
    fi

    # Create a sample page and post
    echo "Creating sample content..."
    docker-compose exec wordpress bash -c "wp post create --post_type=page --post_status=publish --post_title='About Us' --post_content='This is the about page content.' --post_author=1 --allow-root" || echo "Warning: Could not create About Us page"

    docker-compose exec wordpress bash -c "wp post create --post_type=post --post_status=publish --post_title='Welcome to Our New Website' --post_content='This is our first blog post. Welcome to our website!' --post_author=1 --allow-root" || echo "Warning: Could not create sample post"

    # Update home page settings
    echo "Setting up front page..."
    docker-compose exec wordpress bash -c "wp option update show_on_front 'page' --allow-root" || echo "Warning: Could not set front page display"
    
    # Get the ID of the About Us page with error handling
    HOMEPAGE_ID=$(docker-compose exec wordpress bash -c "wp post list --post_type=page --name=about-us --field=ID --allow-root" 2>/dev/null)
    if [ -n "$HOMEPAGE_ID" ]; then
        docker-compose exec wordpress bash -c "wp option update page_on_front $HOMEPAGE_ID --allow-root" || echo "Warning: Could not set the front page"
    else
        echo "Warning: Could not find the About Us page ID"
    fi

    # Activate plugins
    echo "Activating plugins..."
    docker-compose exec wordpress bash -c "wp plugin activate simple-contact-form --allow-root" || echo "Warning: Could not activate Simple Contact Form plugin"

    echo "WordPress installation completed successfully!"
fi

echo ""
echo "Your WordPress site is now ready!"
echo "--------------------------------"
echo "URL: $WORDPRESS_SITE_URL"
echo "Admin URL: $WORDPRESS_SITE_URL/wp-admin"
echo "Username: $WORDPRESS_ADMIN_USER"
echo "Password: $WORDPRESS_ADMIN_PASSWORD"
echo ""
echo "phpMyAdmin: http://localhost:8080"
echo "Database Name: $(read_env_var "WORDPRESS_DB_NAME" "wordpress")"
echo "Database User: $(read_env_var "WORDPRESS_DB_USER" "wordpress")"
echo "Database Password: $(read_env_var "WORDPRESS_DB_PASSWORD" "wordpress")"
echo ""
echo "If you encounter any issues, check the Docker logs with:"
echo "docker-compose logs wordpress"
echo ""
