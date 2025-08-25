#!/bin/bash

# Build script for custom Liquibase image
# This script builds the custom Liquibase image with MySQL driver pre-installed

set -e

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

IMAGE_NAME="mysql-liquibase-custom"
DOCKERFILE_PATH="database"

case "${1:-build}" in
    "build")
        print_status "Building custom Liquibase image: $IMAGE_NAME"
        docker build -t "$IMAGE_NAME" "$DOCKERFILE_PATH"
        print_status "Build completed successfully!"
        
        print_status "Image details:"
        docker images | grep "$IMAGE_NAME" || print_warning "Image not found in local registry"
        ;;
    
    "rebuild")
        print_warning "Rebuilding image without cache..."
        docker build --no-cache -t "$IMAGE_NAME" "$DOCKERFILE_PATH"
        print_status "Rebuild completed successfully!"
        ;;
    
    "info")
        print_status "Image information:"
        if docker images | grep -q "$IMAGE_NAME"; then
            docker images | head -1
            docker images | grep "$IMAGE_NAME"
            echo ""
            print_status "Image layers:"
            docker history "$IMAGE_NAME"
        else
            print_error "Image '$IMAGE_NAME' not found. Run './build.sh build' to create it."
        fi
        ;;
    
    "clean")
        print_warning "Removing custom Liquibase image..."
        if docker images | grep -q "$IMAGE_NAME"; then
            docker rmi "$IMAGE_NAME"
            print_status "Image removed successfully!"
        else
            print_warning "Image '$IMAGE_NAME' not found."
        fi
        ;;
    
    "help"|*)
        echo "Custom Liquibase Image Build Script"
        echo ""
        echo "Usage: $0 <command>"
        echo ""
        echo "Commands:"
        echo "  build     Build the custom Liquibase image (default)"
        echo "  rebuild   Rebuild the image without using cache"
        echo "  info      Show image information and layers"
        echo "  clean     Remove the custom image"
        echo "  help      Show this help message"
        echo ""
        echo "Examples:"
        echo "  $0 build     # Build the image"
        echo "  $0 rebuild   # Force rebuild without cache"
        echo "  $0 info      # Show image details"
        echo ""
        ;;
esac
