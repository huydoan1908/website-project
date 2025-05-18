#!/bin/bash

# Helper script to run WP-CLI commands in the Docker container

# Function to display help message
show_help() {
    echo "WordPress CLI Docker Helper"
    echo "--------------------------"
    echo "Usage: ./wp-cli.sh [wp-cli command]"
    echo ""
    echo "Examples:"
    echo "  ./wp-cli.sh plugin list"
    echo "  ./wp-cli.sh theme activate custom-theme"
    echo "  ./wp-cli.sh post list"
    echo "  ./wp-cli.sh user create newuser newuser@example.com --role=editor"
    echo ""
    echo "For more WP-CLI commands, see: https://wp-cli.org/commands/"
    echo ""
}

# If no arguments provided, show help message
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# If help requested, show help message
if [ "$1" == "help" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    show_help
    exit 0
fi

# Check if Docker is running and WordPress container exists
if ! docker ps | grep -q "website-project.*wordpress"; then
    echo "Error: WordPress container is not running. Please start it with './manage-wp.sh start'"
    exit 1
fi

# Run WP-CLI command in the WordPress container
docker-compose exec wordpress wp "$@" --allow-root
