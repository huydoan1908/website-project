# WordPress Local Development Guide

This guide provides instructions for using this simplified WordPress development environment. All production-related components have been removed to create a clean, focused development workflow.

## Quick Start

1. **Start the environment**:
   ```bash
   ./manage-wp.sh start
   ```
   Or use the Makefile:
   ```bash
   make start
   ```

2. **Initialize WordPress** (if not already installed):
   ```bash
   ./init-wordpress.sh
   ```
   Or use the Makefile:
   ```bash
   make initialize
   ```

3. **Access your WordPress site**:
   - WordPress: http://localhost:8000
   - WordPress admin: http://localhost:8000/wp-admin
     - Username: admin
     - Password: admin
   - phpMyAdmin: http://localhost:8080
     - Server: db
     - Username: wordpress
     - Password: wordpress

## Development Workflow

### Theme Development

The custom theme is located at `wp-content/themes/custom-theme/`. Make changes to these files for theme customization:

- `style.css` - Theme styling
- `functions.php` - Theme functions and customizations
- `header.php` - Site header template
- `footer.php` - Site footer template
- `index.php` - Main template file
- `single.php` - Single post template
- `page.php` - Page template

After making changes, refresh your browser to see them immediately.

### Plugin Development

Custom plugins can be developed in these locations:

1. **Simple Contact Form Plugin**: `wp-content/plugins/simple-contact-form/`
2. **Custom Plugins Directory**: `custom-plugins/` (mapped to WordPress plugins directory)

### Using WP-CLI

The environment includes WP-CLI for WordPress management:

```bash
# Run a WP-CLI command
./wp-cli.sh <command>

# Examples:
./wp-cli.sh plugin list
./wp-cli.sh theme activate custom-theme
./wp-cli.sh user list
```

Or use the Makefile:
```bash
make wp-cli cmd="plugin list"
```

### Database Operations

#### Backup Database
```bash
./db-backup.sh
```
Or use the Makefile:
```bash
make backup
```

#### Restore Database
```bash
./db-restore.sh
```

### Environment Management

```bash
# Start environment
./manage-wp.sh start

# Stop environment
./manage-wp.sh stop

# Restart environment
./manage-wp.sh restart

# Check environment status
./manage-wp.sh status

# View WordPress logs
./manage-wp.sh logs

# Complete environment check
make dev-check
```

## Customization

### Environment Variables
Edit the `.env` file to customize WordPress settings, database credentials, and more.

### PHP Settings
Edit `uploads.ini` to customize PHP settings like upload limits and memory usage.

### WordPress Configuration
Edit `wp-config-local.php` to customize WordPress behavior like debug settings.

## Troubleshooting

1. **Run health check**:
   ```bash
   ./health-check.sh
   ```
   Or use the Makefile:
   ```bash
   make health-check
   ```

2. **Check container status**:
   ```bash
   docker-compose ps
   ```

3. **Check logs**:
   ```bash
   docker-compose logs wordpress
   ```

4. **Restart the environment**:
   ```bash
   ./manage-wp.sh restart
   ```

5. **Full development environment check**:
   ```bash
   make dev-check
   ```
