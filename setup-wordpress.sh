#!/bin/bash

# Interactive WordPress setup script
echo "WordPress Setup Script"
echo "======================"
echo ""

# Check if Docker is running
if ! docker ps &>/dev/null; then
  echo "Error: Docker is not running. Please start Docker and try again."
  exit 1
fi

# Check if WordPress container is running
if ! docker ps | grep -q "wordpress"; then
  echo "Starting WordPress container..."
  docker-compose up -d
  echo "Waiting for containers to start..."
  sleep 10
fi

# Install WP-CLI in the container
echo "Setting up WP-CLI..."
docker-compose exec wordpress bash -c "if [ ! -f /usr/local/bin/wp ]; then curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp; fi"

# Check if WP-CLI is working
if ! docker-compose exec wordpress wp --info --allow-root &>/dev/null; then
  echo "Error: WP-CLI installation failed. Please try again."
  exit 1
fi

echo "WP-CLI installed successfully."

# Check if WordPress is already installed
if docker-compose exec wordpress wp core is-installed &>/dev/null; then
  echo "WordPress is already installed."
  echo "You can access your site at http://localhost:8000"
  echo "Admin URL: http://localhost:8000/wp-admin"
  exit 0
fi

# Get configuration from user
echo ""
echo "Please provide the following information to set up WordPress:"
echo "(Press Enter to use the default values)"

read -p "Site Title [My WordPress Site]: " site_title
site_title=${site_title:-"My WordPress Site"}

read -p "Admin Username [admin]: " admin_user
admin_user=${admin_user:-"admin"}

read -p "Admin Password [admin]: " admin_password
admin_password=${admin_password:-"admin"}

read -p "Admin Email [admin@example.com]: " admin_email
admin_email=${admin_email:-"admin@example.com"}

# Install WordPress
echo ""
echo "Installing WordPress..."
docker-compose exec wordpress wp core install \
  --url=http://localhost:8000 \
  --title="$site_title" \
  --admin_user="$admin_user" \
  --admin_password="$admin_password" \
  --admin_email="$admin_email" \
  --skip-email

if [ $? -ne 0 ]; then
  echo "Error: WordPress installation failed."
  exit 1
fi

echo "Configuring WordPress settings..."
docker-compose exec wordpress wp option update blogdescription "Just another WordPress site"
docker-compose exec wordpress wp option update timezone_string "America/New_York"
docker-compose exec wordpress wp option update permalink_structure "/%postname%/"

echo "Activating custom theme..."
if docker-compose exec wordpress wp theme is-installed custom-theme; then
  docker-compose exec wordpress wp theme activate custom-theme
  echo "Custom theme activated."
else
  echo "Custom theme not found. Showing available themes:"
  docker-compose exec wordpress wp theme list
fi

echo "Creating sample content..."
docker-compose exec wordpress wp post create \
  --post_type=page \
  --post_status=publish \
  --post_title="About Us" \
  --post_content="This is the about page content." \
  --post_author=1

docker-compose exec wordpress wp post create \
  --post_type=post \
  --post_status=publish \
  --post_title="Welcome to Our New Website" \
  --post_content="This is our first blog post. Welcome to our website!" \
  --post_author=1

echo "Setting up front page..."
docker-compose exec wordpress wp option update show_on_front "page"
page_id=$(docker-compose exec wordpress wp post list --post_type=page --field=ID --posts_per_page=1)
docker-compose exec wordpress wp option update page_on_front "$page_id"

echo ""
echo "WordPress installation completed successfully!"
echo "=============================================="
echo "URL: http://localhost:8000"
echo "Admin URL: http://localhost:8000/wp-admin"
echo "Username: $admin_user"
echo "Password: $admin_password"
echo ""
echo "phpMyAdmin: http://localhost:8080"
echo "Database Name: wordpress"
echo "Database User: wordpress"
echo "Database Password: wordpress"
echo ""
