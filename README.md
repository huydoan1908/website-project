# WordPress Docker Development Setup

A simplified Docker-based WordPress development environment with all necessary configurations and helper scripts for local development.

## Features

- WordPress with MySQL and phpMyAdmin
- Custom theme skeleton
- Environment variable configuration
- Helper scripts for common tasks
- Automatic WordPress initialization
- Backup and restore functionality
- WP-CLI integration
- Health check monitoring

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/downloads) (optional)
- Bash shell (Git Bash on Windows)

## Quick Start

1. Clone this repository:
   ```bash
   git clone <your-repository-url>
   cd website-project
   ```

2. Run the first-time setup script (recommended for new developers):
   ```bash
   ./first-run-setup.sh
   ```

   This script will:
   - Check your system for prerequisites
   - Create a default .env file if needed
   - Start Docker containers
   - Install and configure WordPress
   - Run health checks
   - Provide instructions for next steps

   **Alternative manual setup:**

   Make the scripts executable (if needed):
   ```bash
   chmod +x *.sh
   ```

   Start Docker containers:
   ```bash
   ./manage-wp.sh start
   ```

   Initialize WordPress:
   ```bash
   ./init-wordpress.sh
   ```

3. Access your WordPress site:
   - WordPress: http://localhost:8000
   - WordPress admin: http://localhost:8000/wp-admin
   - Username: admin
   - Password: admin (defined in .env file)

For detailed setup instructions, refer to [SETUP-GUIDE.md](./SETUP-GUIDE.md).

## Available Scripts

- `./manage-wp.sh`: Main management script
  - `start`: Start the WordPress environment
  - `stop`: Stop the WordPress environment
  - `restart`: Restart the WordPress environment
  - `status`: Show container status
  - `logs`: View WordPress container logs
  - `db-backup`: Backup the database
  - `clean`: Remove all containers and volumes (use with caution)

- `./wp-cli.sh`: Run WP-CLI commands in the Docker container
  - Example: `./wp-cli.sh plugin install contact-form-7 --activate`

- `./backup.sh`: Create a complete backup of the WordPress site
- `./health-check.sh`: Check the health of the WordPress environment
- `./init-wordpress.sh`: Initialize a new WordPress installation

## Configuration

- Environment variables are stored in the `.env` file
- Docker configuration is in `docker-compose.yml` and `docker-compose.override.yml`
- PHP upload settings are in `uploads.ini`
- WordPress configuration overrides are in `wp-config-local.php`

## Documentation

- [SETUP-GUIDE.md](./SETUP-GUIDE.md) - Detailed setup instructions for new developers
- [DEVELOPMENT.md](./DEVELOPMENT.md) - Development workflow and best practices
- [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Solutions for common issues

## Project Structure

```
website-project/
├── .env                      # Environment variables
├── backup.sh                 # Backup script
├── db-backup.sh              # Database backup script
├── db-restore.sh             # Database restore script
├── docker-compose.yml        # Main Docker configuration
├── docker-compose.override.yml # Docker override for phpMyAdmin
├── health-check.sh           # Health check script
├── init-wordpress.sh         # WordPress initialization script
├── manage-wp.sh              # Main management script
├── README.md                 # This file
├── setup-wordpress.sh        # Interactive WordPress setup
├── uploads.ini               # PHP upload configuration
├── wp-cli.sh                 # WP-CLI helper script
├── wp-cli.yml                # WP-CLI configuration
├── wp-config-local.php       # Local WordPress configuration
└── wp-content/               # WordPress content directory
    ├── plugins/              # WordPress plugins
    │   └── simple-contact-form/ # Custom contact form plugin
    ├── themes/               # WordPress themes
    │   └── custom-theme/     # Custom theme
    └── uploads/              # WordPress uploads
```

## Development Workflow

1. Start the environment: `./manage-wp.sh start`
2. Make changes to the theme or plugins in the `wp-content` directory
3. Access the site at http://localhost:8000 to see your changes
4. Use `./wp-cli.sh` to manage WordPress via the command line
5. Create backups regularly with `./backup.sh`
6. Stop the environment when done: `./manage-wp.sh stop`

## Default Credentials

- WordPress Admin:
  - Username: admin
  - Password: admin_password (defined in .env)
  - Email: admin@example.com (defined in .env)

- Database:
  - MySQL Root Password: rootpassword
  - Database Name: wordpress
  - Database User: wordpress
  - Database Password: wordpress
  - Host: localhost:3306 (db:3306 inside Docker network)

- phpMyAdmin:
  - URL: http://localhost:8080
  - Server: db
  - Username: wordpress
  - Password: wordpress
