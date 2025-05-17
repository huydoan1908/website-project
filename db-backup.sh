#!/bin/bash

# WordPress database backup script
BACKUP_DIR="./db-dumps"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
DB_BACKUP_PATH="$BACKUP_DIR/wordpress_db_$TIMESTAMP.sql"

echo "WordPress Database Backup Script"
echo "============================="
echo ""

# Check if Docker is running
if ! docker ps &>/dev/null; then
  echo "Error: Docker is not running. Please start Docker and try again."
  exit 1
fi

# Check if WordPress and database containers are running
if ! docker ps | grep -q "db"; then
  echo "Error: Database container not running. Please start the containers first with 'docker-compose up -d'"
  exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Creating database backup..."
if docker-compose exec db mysqldump -u wordpress -pwordpress wordpress > "$DB_BACKUP_PATH"; then
  echo "✅ Backup created successfully: $DB_BACKUP_PATH"
  echo "Backup size: $(du -h "$DB_BACKUP_PATH" | cut -f1)"
else
  echo "❌ Failed to create database backup."
  exit 1
fi

# Compress the backup to save space
echo "Compressing backup..."
if gzip -f "$DB_BACKUP_PATH"; then
  echo "✅ Backup compressed: $DB_BACKUP_PATH.gz"
  echo "Compressed size: $(du -h "$DB_BACKUP_PATH.gz" | cut -f1)"
else
  echo "❌ Failed to compress backup."
fi

echo ""
echo "Available backups:"
ls -lh "$BACKUP_DIR" | grep ".sql.gz"

echo ""
echo "To restore this backup, run:"
echo "docker-compose exec db mysql -u wordpress -pwordpress wordpress < $DB_BACKUP_PATH"
echo ""
