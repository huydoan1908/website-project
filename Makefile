# WordPress Docker Project Makefile

.PHONY: start stop restart status logs backup initialize wp-cli health-check clean cleanup-production dev-check setup help

# Default target when running 'make' without arguments
help:
	@echo "WordPress Docker Project Makefile"
	@echo "---------------------------------"
	@echo "Available commands:"
	@echo "  make start        - Start the WordPress environment"
	@echo "  make stop         - Stop the WordPress environment"
	@echo "  make restart      - Restart the WordPress environment"
	@echo "  make status       - Show container status"
	@echo "  make logs         - View WordPress container logs"
	@echo "  make backup       - Create a backup of WordPress"
	@echo "  make initialize   - Initialize WordPress installation"
	@echo "  make wp-cli cmd=COMMAND - Run a WP-CLI command"
	@echo "  make health-check - Check environment health"
	@echo "  make dev-check    - Complete development environment check"
	@echo "  make clean        - Remove all containers and volumes"
	@echo "  make cleanup-production - Remove all production-related components"
	@echo "  make setup        - Run the first-run setup script for new developers"
	@echo "  make help         - Show this help message"

# Start WordPress environment
start:
	@echo "Starting WordPress environment..."
	@bash ./manage-wp.sh start

# Stop WordPress environment
stop:
	@echo "Stopping WordPress environment..."
	@bash ./manage-wp.sh stop

# Restart WordPress environment
restart:
	@echo "Restarting WordPress environment..."
	@bash ./manage-wp.sh restart

# Show status of WordPress environment
status:
	@bash ./manage-wp.sh status

# Show logs of WordPress container
logs:
	@bash ./manage-wp.sh logs

# Create a backup of WordPress
backup:
	@bash ./backup.sh

# Initialize WordPress
initialize:
	@bash ./init-wordpress.sh

# Run WP-CLI command
wp-cli:
	@bash ./wp-cli.sh $(cmd)

# Run health check
health-check:
	@bash ./health-check.sh

# Clean up environment
clean:
	@echo "WARNING: This will remove all containers and volumes!"
	@echo "Are you sure you want to continue? (y/n)"
	@read -p "" confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		bash ./manage-wp.sh clean; \
	else \
		echo "Operation cancelled."; \
	fi

# Clean up production components
cleanup-production:
	@bash ./cleanup-production.sh

# Complete development environment check
dev-check:
	@echo "Checking WordPress development environment..."
	@bash ./health-check.sh
	@echo ""
	@echo "Checking WordPress installation..."
	@docker-compose exec wordpress wp core version --allow-root || echo "WordPress core not installed or accessible"
	@echo ""
	@echo "Checking database..."
	@docker-compose exec db mysql -u wordpress -pwordpress -e "SHOW TABLES FROM wordpress;" || echo "Could not connect to database"
	@echo ""
	@echo "Checking custom theme..."
	@docker-compose exec wordpress wp theme status custom-theme --allow-root || echo "Custom theme not found"
	@echo ""
	@echo "Environment check complete!"

# Run first-run setup script
setup:
	@echo "Running first-run setup script..."
	@bash ./first-run-setup.sh
