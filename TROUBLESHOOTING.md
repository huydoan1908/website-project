# WordPress Docker Environment - Troubleshooting Guide

This guide helps resolve common issues you might encounter when setting up or working with the WordPress Docker development environment.

## Container Issues

### Containers Won't Start

**Symptoms:**
- `docker-compose up -d` fails
- Error messages about ports being in use

**Solutions:**
1. Check if ports 8000, 8080, or 3306 are already in use:
   ```bash
   lsof -i :8000
   lsof -i :8080
   lsof -i :3306
   ```

2. If ports are in use, either:
   - Stop the services using those ports
   - Modify the port mappings in `docker-compose.yml`

3. Ensure Docker daemon is running:
   ```bash
   docker info
   ```

4. Check for container name conflicts:
   ```bash
   docker ps -a | grep website-project
   ```
   
   If conflicts exist, remove them:
   ```bash
   docker rm -f $(docker ps -a -q --filter name=website-project)
   ```

### Containers Stop Unexpectedly

**Symptoms:**
- Docker containers stop shortly after starting
- Health check shows containers not running

**Solutions:**
1. Check Docker logs:
   ```bash
   docker-compose logs
   ```

2. Check for resource constraints:
   - Increase Docker's allocated memory in Docker Desktop settings
   - Check system resources with `top` or Task Manager

3. Verify Docker storage:
   ```bash
   docker system df
   ```
   
   Clean up if needed:
   ```bash
   docker system prune -a
   ```

## WordPress Issues

### WordPress Not Responding

**Symptoms:**
- Browser shows "Connection refused" or timeout
- Health check fails for WordPress site

**Solutions:**
1. Check if WordPress container is running:
   ```bash
   docker-compose ps wordpress
   ```

2. Check WordPress container logs:
   ```bash
   docker-compose logs wordpress
   ```

3. Restart the WordPress container:
   ```bash
   docker-compose restart wordpress
   ```

4. Check WordPress error log inside container:
   ```bash
   docker-compose exec wordpress cat /var/www/html/wp-content/debug.log
   ```

### WordPress Installation Fails

**Symptoms:**
- `init-wordpress.sh` script reports errors
- WordPress admin area not accessible

**Solutions:**
1. Check if WP-CLI is installed:
   ```bash
   docker-compose exec wordpress wp --info --allow-root
   ```
   
   If not, install it:
   ```bash
   docker-compose exec wordpress bash -c "curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp"
   ```

2. Check database connection:
   ```bash
   docker-compose exec wordpress wp db check --allow-root
   ```

3. Try manual installation:
   ```bash
   docker-compose exec wordpress wp core install --url=http://localhost:8000 --title="WordPress Site" --admin_user=admin --admin_password=admin --admin_email=admin@example.com --skip-email --allow-root
   ```

## Database Issues

### Database Connection Errors

**Symptoms:**
- WordPress shows "Error establishing a database connection"
- WP-CLI database commands fail

**Solutions:**
1. Verify MySQL container is running:
   ```bash
   docker-compose ps db
   ```

2. Check MySQL logs:
   ```bash
   docker-compose logs db
   ```

3. Verify database credentials in `.env` match those in `docker-compose.yml`

4. Try connecting to the database directly:
   ```bash
   docker-compose exec db mysql -u wordpress -pwordpress wordpress -e "SHOW TABLES;"
   ```

5. Check if database was initialized:
   ```bash
   docker-compose exec db mysql -u wordpress -pwordpress -e "SHOW DATABASES;"
   ```

### Database Import/Export Issues

**Symptoms:**
- Database backup/restore scripts fail
- Errors about permissions or file formats

**Solutions:**
1. Check file permissions for db-dumps directory:
   ```bash
   ls -la db-dumps/
   ```

2. Make sure SQL files are properly formatted and not corrupted

3. For large databases, increase memory limit:
   ```bash
   docker-compose exec db sh -c "echo 'max_allowed_packet=64M' >> /etc/mysql/conf.d/docker.cnf"
   docker-compose restart db
   ```

## WP-CLI Issues

### WP-CLI Commands Fail

**Symptoms:**
- `wp-cli.sh` script returns errors
- Permission denied errors

**Solutions:**
1. Make sure the `--allow-root` flag is included in WP-CLI commands:
   ```bash
   docker-compose exec wordpress wp plugin list --allow-root
   ```

2. Check if WP-CLI is properly installed:
   ```bash
   docker-compose exec wordpress which wp
   ```

3. Update WP-CLI if needed:
   ```bash
   docker-compose exec wordpress wp cli update --allow-root
   ```

4. Verify WP-CLI configuration:
   ```bash
   docker-compose exec wordpress cat /var/www/html/wp-cli.yml
   ```

## File System Issues

### File Permission Problems

**Symptoms:**
- WordPress reports upload issues
- Cannot install/update plugins or themes

**Solutions:**
1. Fix permissions inside container:
   ```bash
   docker-compose exec wordpress chown -R www-data:www-data /var/www/html/wp-content
   ```

2. Check mounted volumes in `docker-compose.yml`

3. Ensure `uploads.ini` has appropriate settings:
   ```bash
   cat uploads.ini
   ```

## Advanced Troubleshooting

### Complete Environment Reset

If you encounter persistent issues, you can perform a complete reset:

1. Stop and remove all containers:
   ```bash
   docker-compose down
   ```

2. Remove volumes (CAUTION: This deletes all data):
   ```bash
   docker-compose down -v
   ```

3. Clean up Docker system:
   ```bash
   docker system prune
   ```

4. Start from scratch:
   ```bash
   ./first-run-setup.sh
   ```

### Checking WordPress Configuration

If WordPress behaves unexpectedly, examine the actual configuration:

```bash
docker-compose exec wordpress wp config get --format=json --allow-root
```

### Debug Mode Commands

For debugging issues, enable debugging and check logs:

```bash
# Enable all debugging
docker-compose exec wordpress wp config set WP_DEBUG true --raw --allow-root
docker-compose exec wordpress wp config set WP_DEBUG_LOG true --raw --allow-root
docker-compose exec wordpress wp config set WP_DEBUG_DISPLAY false --raw --allow-root

# View error log
docker-compose exec wordpress tail -f /var/www/html/wp-content/debug.log
```

## Getting Help

If you're still experiencing issues after trying these troubleshooting steps:

1. Create a detailed bug report including:
   - Exact error messages
   - Steps to reproduce
   - Docker and system version info

2. Check the project's issue tracker for similar issues

3. When posting for help, include relevant logs:
   ```bash
   docker-compose logs > docker-logs.txt
   ```
