#!/bin/bash

# WordPress Docker management script

# Check for Docker and Docker Compose
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

# Function to display help message
show_help() {
    echo "WordPress Docker Management Script"
    echo "--------------------------------"
    echo "Usage: ./manage-wp.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start       Start the WordPress Docker environment"
    echo "  stop        Stop the WordPress Docker environment"
    echo "  restart     Restart the WordPress Docker environment"
    echo "  status      Show the status of the Docker containers"
    echo "  logs        Show logs from the WordPress container"
    echo "  db-backup   Backup the WordPress database"
    echo "  clean       Remove all containers and volumes (CAUTION: Deletes all data)"
    echo "  help        Show this help message"
    echo ""
}

# Function to start the environment
start_environment() {
    echo "Starting WordPress Docker environment..."
    
    # Check if .env file exists
    if [ ! -f .env ]; then
        echo "Warning: .env file not found. This may cause issues."
    fi
    
    # Check if docker-compose.yml exists
    if [ ! -f docker-compose.yml ]; then
        echo "Error: docker-compose.yml not found"
        exit 1
    fi
    
    # Start containers with error handling
    if ! docker-compose up -d; then
        echo "Error: Failed to start Docker containers"
        echo "Please check the Docker error message above"
        exit 1
    fi
    
    # Wait for containers to be ready
    echo "Waiting for containers to be ready..."
    sleep 5
    
    # Verify containers are running
    if ! docker-compose ps | grep -q "wordpress.*Up"; then
        echo "Warning: WordPress container might not be running properly"
        echo "Current container status:"
        docker-compose ps
    else
        echo "WordPress environment started successfully!"
    fi
    
    echo "WordPress site: http://localhost:8000"
    echo "phpMyAdmin: http://localhost:8080"
}

# Function to stop the environment
stop_environment() {
    echo "Stopping WordPress Docker environment..."
    docker-compose down
    echo "WordPress environment stopped!"
}

# Function to restart the environment
restart_environment() {
    echo "Restarting WordPress Docker environment..."
    docker-compose down
    docker-compose up -d
    echo "WordPress environment restarted!"
    echo "WordPress site: http://localhost:8000"
    echo "phpMyAdmin: http://localhost:8080"
}

# Function to show container status
show_status() {
    echo "Container status:"
    docker-compose ps
}

# Function to show logs
show_logs() {
    echo "WordPress container logs:"
    docker-compose logs wordpress
}

# Function to backup the database
backup_database() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_DIR="./db-backups"
    
    # Create backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"
    
    echo "Creating database backup..."
    docker-compose exec db sh -c 'exec mysqldump -uwordpress -pwordpress wordpress' > "$BACKUP_DIR/wordpress_db_$TIMESTAMP.sql"
    echo "Database backup created at $BACKUP_DIR/wordpress_db_$TIMESTAMP.sql"
}

# Function to clean up environment (remove all containers and volumes)
clean_environment() {
    echo "WARNING: This will remove all containers and volumes, deleting all data!"
    read -p "Are you sure you want to continue? (y/n): " confirm
    
    if [[ $confirm == "y" || $confirm == "Y" ]]; then
        echo "Removing all containers and volumes..."
        docker-compose down -v
        echo "All containers and volumes removed!"
    else
        echo "Operation cancelled."
    fi
}

# Main script logic
case "$1" in
    start)
        start_environment
        ;;
    stop)
        stop_environment
        ;;
    restart)
        restart_environment
        ;;
    status)
        show_status
        ;;
    logs)
        show_logs
        ;;
    db-backup)
        backup_database
        ;;
    clean)
        clean_environment
        ;;
    help|*)
        show_help
        ;;
esac
