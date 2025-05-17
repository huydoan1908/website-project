# WordPress Docker Development Environment - Setup Guide

This guide walks you through the complete setup process for new developers joining the project. Follow these steps to get your local development environment running quickly.

## Prerequisites

Before you begin, make sure you have the following installed on your system:

- [Docker](https://www.docker.com/get-started) (Windows/Mac: Docker Desktop, Linux: Docker Engine)
- [Docker Compose](https://docs.docker.com/compose/install/) (included with Docker Desktop)
- [Git](https://git-scm.com/downloads) for version control
- Bash shell (Windows users: [Git Bash](https://gitforwindows.org/) is recommended)

## Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd website-project
```

### 2. Make Scripts Executable (Linux/Mac only)

If you're on Linux or Mac, make the scripts executable:

```bash
chmod +x *.sh
```

Windows users using Git Bash can skip this step.

### 3. Check Environment Variables

The `.env` file contains all environment variables needed for the project. Review and modify if needed:

```bash
# View the .env file contents
cat .env
```

Key variables to check:
- `WORDPRESS_SITE_TITLE` - The title of your WordPress site
- `WORDPRESS_ADMIN_USER` - Admin username (default: admin)
- `WORDPRESS_ADMIN_PASSWORD` - Admin password (default: admin)
- `WORDPRESS_ADMIN_EMAIL` - Admin email

### 4. Start Docker Containers

Start the Docker containers using the management script:

```bash
./manage-wp.sh start
```

Or using the Makefile:

```bash
make start
```

This will start three containers:
- WordPress (http://localhost:8000)
- MySQL database
- phpMyAdmin (http://localhost:8080)

### 5. Run Health Check

Verify that all containers are running properly:

```bash
./health-check.sh
```

Or using the Makefile:

```bash
make health-check
```

You should see all services reporting as operational.

### 6. Initialize WordPress

If this is your first time setting up the environment, you need to initialize WordPress:

```bash
./init-wordpress.sh
```

Or using the Makefile:

```bash
make initialize
```

This script will:
- Check if WordPress is already installed
- Install WordPress with default settings if needed
- Configure basic settings
- Create sample content

### 7. Access WordPress

Once the setup is complete, you can access:

- WordPress site: http://localhost:8000
- WordPress admin: http://localhost:8000/wp-admin
  - Username: admin
  - Password: admin (or as defined in .env)
- phpMyAdmin: http://localhost:8080
  - Server: db
  - Username: wordpress
  - Password: wordpress

## Environment Variables

The project uses environment variables stored in the `.env` file to configure various aspects of the WordPress environment. These variables are used by both Docker Compose and the WordPress initialization scripts.

### Key Environment Variables

| Variable | Description | Default Value |
|----------|-------------|---------------|
| `WORDPRESS_SITE_TITLE` | The title of your WordPress site | My WordPress Site |
| `WORDPRESS_ADMIN_USER` | WordPress admin username | admin |
| `WORDPRESS_ADMIN_PASSWORD` | WordPress admin password | admin |
| `WORDPRESS_ADMIN_EMAIL` | WordPress admin email | admin@example.com |
| `WORDPRESS_SITE_URL` | The URL of your WordPress site | http://localhost:8000 |
| `WORDPRESS_DB_NAME` | WordPress database name | wordpress |
| `WORDPRESS_DB_USER` | WordPress database user | wordpress |
| `WORDPRESS_DB_PASSWORD` | WordPress database password | wordpress |
| `MYSQL_ROOT_PASSWORD` | MySQL root password | rootpassword |

### Customizing Environment Variables

You can customize any of these variables by editing the `.env` file. For example, to change the WordPress admin password:

1. Open the `.env` file in your editor
2. Find the line with `WORDPRESS_ADMIN_PASSWORD=admin`
3. Change it to `WORDPRESS_ADMIN_PASSWORD=your_secure_password`
4. Save the file

After changing environment variables that affect WordPress configuration, you may need to restart the environment:

```bash
./manage-wp.sh restart
```

Note: If you change database credentials after WordPress is already installed, you'll need to update the WordPress configuration to match.

## Common Issues & Troubleshooting

### Port Conflicts

If you see errors about ports being in use, you may have another service using ports 8000, 8080, or 3306. You can modify the port mappings in `docker-compose.yml`.

### Database Connection Issues

If WordPress cannot connect to the database:

1. Ensure all containers are running: `docker-compose ps`
2. Check Docker network connectivity: `docker network inspect website-project_wpsite`
3. Review database credentials in `.env` file

### WordPress Installation Fails

If WordPress installation fails:

1. Check Docker logs: `docker-compose logs wordpress`
2. Ensure MySQL container is running: `docker-compose logs db`
3. Try restarting containers: `./manage-wp.sh restart`

### WP-CLI Issues

If you encounter issues with WP-CLI commands:

1. Ensure WP-CLI is installed in the WordPress container
2. Use the `--allow-root` flag if necessary
3. Check that the WordPress container is running

## Working with the Environment

### Using WP-CLI

The repository includes a helper script for running WP-CLI commands:

```bash
./wp-cli.sh <command>

# Examples:
./wp-cli.sh plugin list
./wp-cli.sh theme activate custom-theme
./wp-cli.sh user list
```

### Database Backups

Create a database backup:

```bash
./db-backup.sh
```

Restore from a backup:

```bash
./db-restore.sh db-dumps/your-backup-file.sql.gz
```

### Stopping the Environment

When you're done working, stop the environment:

```bash
./manage-wp.sh stop
```

Or using the Makefile:

```bash
make stop
```

## Next Steps

Once your environment is set up, refer to `DEVELOPMENT.md` for detailed information about the development workflow.
