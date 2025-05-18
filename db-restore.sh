#!/bin/bash

# WordPress database restore script
BACKUP_DIR="./db-dumps"

echo "WordPress Database Restore Script"
echo "================================"
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

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Error: Backup directory $BACKUP_DIR does not exist."
  exit 1
fi

# List available backups
echo "Available backups:"
if [ -z "$(ls -A $BACKUP_DIR)" ]; then
  echo "No backups found in $BACKUP_DIR"
  exit 1
fi

# Create a numbered list of available backups
backup_files=()
i=1
for file in $BACKUP_DIR/*.sql $BACKUP_DIR/*.sql.gz; do
  if [ -f "$file" ]; then
    echo "$i) $(basename "$file") ($(du -h "$file" | cut -f1))"
    backup_files+=("$file")
    ((i++))
  fi
done

if [ ${#backup_files[@]} -eq 0 ]; then
  echo "No SQL backup files found in $BACKUP_DIR"
  exit 1
fi

# Ask user to select a backup
echo ""
read -p "Enter the number of the backup to restore (or 'q' to quit): " selection

if [[ "$selection" == "q" ]]; then
  echo "Operation canceled."
  exit 0
fi

if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -lt 1 ] || [ "$selection" -gt ${#backup_files[@]} ]; then
  echo "Invalid selection."
  exit 1
fi

selected_backup="${backup_files[$((selection-1))]}"
echo "Selected backup: $selected_backup"

# Confirm before proceeding
echo ""
echo "WARNING: This will overwrite the current WordPress database!"
read -p "Are you sure you want to proceed? (y/n): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Operation canceled."
  exit 0
fi

echo ""
echo "Restoring database from backup..."

# Check if the backup is compressed
if [[ "$selected_backup" == *.gz ]]; then
  echo "Decompressing backup..."
  gunzip -c "$selected_backup" | docker-compose exec -T db mysql -u wordpress -pwordpress wordpress
else
  cat "$selected_backup" | docker-compose exec -T db mysql -u wordpress -pwordpress wordpress
fi

if [ $? -eq 0 ]; then
  echo "✅ Database restored successfully!"
else
  echo "❌ Failed to restore database."
  exit 1
fi

echo ""
echo "You may need to update WordPress URLs if you restored from a different environment."
echo "Run the following commands if needed:"
echo "docker-compose exec wordpress wp option update home 'http://localhost:8000' --allow-root"
echo "docker-compose exec wordpress wp option update siteurl 'http://localhost:8000' --allow-root"
echo ""
