#!/bin/bash

# Liquibase Migration Helper Script
# This script provides convenient commands for managing database migrations

set -e

NETWORK_NAME="mysql_default"
LIQUIBASE_IMAGE="mysql-liquibase-custom"
DB_URL="jdbc:mysql://db:3306/store"
DB_USER="user"
DB_PASSWORD="password"
CHANGELOG_FILE="changelog-master.xml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if docker network exists
check_network() {
    if ! docker network ls | grep -q "$NETWORK_NAME"; then
        print_error "Docker network '$NETWORK_NAME' not found."
        print_error "Please run 'docker-compose up -d' first to create the network."
        exit 1
    fi
}

# Function to run liquibase command
run_liquibase() {
    local command=$1
    print_status "Running Liquibase command: $command"
    
    # Check if custom image exists, if not build it
    if ! docker images | grep -q "$LIQUIBASE_IMAGE"; then
        print_status "Building custom Liquibase image..."
        docker build -t "$LIQUIBASE_IMAGE" .
    fi
    
    docker run --rm --network "$NETWORK_NAME" \
        -v "$(pwd)/database:/liquibase/changelog" \
        "$LIQUIBASE_IMAGE" \
        --url="$DB_URL" \
        --username="$DB_USER" \
        --password="$DB_PASSWORD" \
        --changeLogFile="$CHANGELOG_FILE" \
        "$command"
}

# Main script logic
case "${1:-help}" in
    "update"|"migrate")
        check_network
        print_status "Applying database migrations..."
        run_liquibase "update"
        print_status "Migration completed successfully!"
        ;;
    "status")
        check_network
        print_status "Checking migration status..."
        run_liquibase "status"
        ;;
    "sql")
        check_network
        print_status "Generating SQL for pending migrations..."
        run_liquibase "updateSQL"
        ;;
    "rollback")
        if [ -z "$2" ]; then
            print_error "Please specify the number of changesets to rollback."
            print_error "Usage: $0 rollback <count>"
            exit 1
        fi
        check_network
        print_warning "Rolling back $2 changeset(s)..."
        run_liquibase "rollbackCount $2"
        print_status "Rollback completed!"
        ;;
    "validate")
        check_network
        print_status "Validating changelog..."
        run_liquibase "validate"
        print_status "Changelog is valid!"
        ;;
    "history")
        check_network
        print_status "Showing migration history..."
        run_liquibase "history"
        ;;
    "help"|*)
        echo "Liquibase Migration Helper"
        echo ""
        echo "Usage: $0 <command> [options]"
        echo ""
        echo "Commands:"
        echo "  update, migrate    Apply all pending migrations"
        echo "  status             Show migration status"
        echo "  sql                Generate SQL for pending migrations (dry run)"
        echo "  rollback <count>   Rollback specified number of changesets"
        echo "  validate           Validate changelog syntax"
        echo "  history            Show migration history"
        echo "  help               Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 update          # Apply all pending migrations"
        echo "  $0 status          # Check current migration status"
        echo "  $0 rollback 1      # Rollback the last migration"
        echo ""
        ;;
esac
