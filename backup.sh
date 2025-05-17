#!/bin/bash

# WordPress Backup Script
# This script will create a backup of the WordPress database and files

# Set backup directory
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_PATH="$BACKUP_DIR/wordpress_backup_$TIMESTAMP"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Create backup subdirectory for this backup
mkdir -p "$BACKUP_PATH"

echo "Starting WordPress backup..."

# Backup database
echo "Backing up database..."
docker-compose exec -T db sh -c 'exec mysqldump -uwordpress -pwordpress wordpress' > "$BACKUP_PATH/database.sql"

# Backup WordPress files
echo "Backing up WordPress files..."
tar -czf "$BACKUP_PATH/wp-content.tar.gz" ./wp-content

# Backup configuration files
echo "Backing up configuration files..."
tar -czf "$BACKUP_PATH/config-files.tar.gz" docker-compose.yml .env uploads.ini wp-config-local.php

# Create a single archive containing all backups
echo "Creating full backup archive..."
tar -czf "$BACKUP_DIR/wordpress_full_backup_$TIMESTAMP.tar.gz" -C "$BACKUP_PATH" .

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -rf "$BACKUP_PATH"

echo "Backup completed successfully!"
echo "Backup saved to: $BACKUP_DIR/wordpress_full_backup_$TIMESTAMP.tar.gz"

# List current backups
echo ""
echo "Available backups:"
ls -lh "$BACKUP_DIR"
