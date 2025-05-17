<?php
/**
 * Custom wp-config settings for local development
 * This will be mounted in the container and included by the main wp-config.php
 */

// Development mode settings
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
define('SCRIPT_DEBUG', true);
define('SAVEQUERIES', true);

// Disable automatic updates
define('AUTOMATIC_UPDATER_DISABLED', true);
define('WP_AUTO_UPDATE_CORE', false);

// Disable post revisions to keep the database clean during development
define('WP_POST_REVISIONS', false);

// Decrease autosave interval to prevent frequent database writes
define('AUTOSAVE_INTERVAL', 300); // 5 minutes

// Disable file editing in the admin to ensure all changes are in version control
define('DISALLOW_FILE_EDIT', true);

// Set development environment
define('WP_ENVIRONMENT_TYPE', 'development');

// Increase memory limit for development
define('WP_MEMORY_LIMIT', '256M');

// Performance optimizations - disable cron in browser
define('DISABLE_WP_CRON', true);

// For development, we can use a faster database connection without SSL
define('MYSQL_CLIENT_FLAGS', 0);
