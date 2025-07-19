#!/bin/bash

# Docker Management Script for Rakshak Expense Management System
# Usage: ./docker-scripts.sh [command]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to check if Docker Compose is available
check_docker_compose() {
    if ! docker-compose --version > /dev/null 2>&1; then
        print_error "Docker Compose is not available. Please install Docker Compose and try again."
        exit 1
    fi
}

# Function to start the application
start_app() {
    print_header "Starting Rakshak Expense Management System"
    check_docker
    check_docker_compose
    
    print_status "Building and starting containers..."
    docker-compose up --build -d
    
    print_status "Waiting for services to be ready..."
    sleep 10
    
    # Check if services are running
    if docker-compose ps | grep -q "Up"; then
        print_status "Application started successfully!"
        print_status "Access the application at: http://localhost:5001"
        print_status "Default admin credentials: admin@rakshak.com / admin123"
    else
        print_error "Failed to start application. Check logs with: ./docker-scripts.sh logs"
        exit 1
    fi
}

# Function to stop the application
stop_app() {
    print_header "Stopping Rakshak Expense Management System"
    check_docker_compose
    
    print_status "Stopping containers..."
    docker-compose down
    
    print_status "Application stopped successfully!"
}

# Function to restart the application
restart_app() {
    print_header "Restarting Rakshak Expense Management System"
    stop_app
    start_app
}

# Function to show logs
show_logs() {
    print_header "Application Logs"
    check_docker_compose
    
    if [ -z "$2" ]; then
        print_status "Showing logs for all services..."
        docker-compose logs -f
    else
        print_status "Showing logs for service: $2"
        docker-compose logs -f "$2"
    fi
}

# Function to show status
show_status() {
    print_header "Application Status"
    check_docker_compose
    
    print_status "Container status:"
    docker-compose ps
    
    echo ""
    print_status "Resource usage:"
    docker stats --no-stream
}

# Function to access container shell
access_shell() {
    print_header "Accessing Container Shell"
    check_docker_compose
    
    if [ -z "$2" ]; then
        print_status "Accessing app container shell..."
        docker-compose exec app sh
    else
        print_status "Accessing $2 container shell..."
        docker-compose exec "$2" sh
    fi
}

# Function to backup database
backup_db() {
    print_header "Database Backup"
    check_docker_compose
    
    BACKUP_DIR="./backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    print_status "Creating database backup..."
    docker-compose exec mongodb mongodump --out /data/backup --db rakshak-expense
    
    print_status "Copying backup to host..."
    docker cp rakshak-mongodb:/data/backup "$BACKUP_DIR"
    
    print_status "Backup completed: $BACKUP_DIR"
}

# Function to restore database
restore_db() {
    print_header "Database Restore"
    check_docker_compose
    
    if [ -z "$2" ]; then
        print_error "Please specify backup directory: ./docker-scripts.sh restore <backup_dir>"
        exit 1
    fi
    
    BACKUP_DIR="$2"
    if [ ! -d "$BACKUP_DIR" ]; then
        print_error "Backup directory not found: $BACKUP_DIR"
        exit 1
    fi
    
    print_warning "This will overwrite the current database. Are you sure? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_status "Restore cancelled."
        exit 0
    fi
    
    print_status "Copying backup to container..."
    docker cp "$BACKUP_DIR" rakshak-mongodb:/data/
    
    print_status "Restoring database..."
    docker-compose exec mongodb mongorestore --db rakshak-expense "/data/$(basename "$BACKUP_DIR")/rakshak-expense"
    
    print_status "Database restored successfully!"
}

# Function to clean up
cleanup() {
    print_header "Cleaning Up Docker Resources"
    check_docker
    
    print_warning "This will remove all containers, images, and volumes. Are you sure? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        print_status "Cleanup cancelled."
        exit 0
    fi
    
    print_status "Stopping and removing containers..."
    docker-compose down -v --rmi all
    
    print_status "Removing unused Docker resources..."
    docker system prune -f
    
    print_status "Cleanup completed!"
}

# Function to show help
show_help() {
    print_header "Docker Management Script"
    echo "Usage: ./docker-scripts.sh [command] [options]"
    echo ""
    echo "Commands:"
    echo "  start           Start the application"
    echo "  stop            Stop the application"
    echo "  restart         Restart the application"
    echo "  logs [service]  Show logs (all services or specific service)"
    echo "  status          Show application status"
    echo "  shell [service] Access container shell (default: app)"
    echo "  backup          Create database backup"
    echo "  restore <dir>   Restore database from backup"
    echo "  cleanup         Clean up all Docker resources"
    echo "  help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./docker-scripts.sh start"
    echo "  ./docker-scripts.sh logs app"
    echo "  ./docker-scripts.sh shell mongodb"
    echo "  ./docker-scripts.sh backup"
    echo "  ./docker-scripts.sh restore ./backup/20241201_120000"
}

# Main script logic
case "$1" in
    "start")
        start_app
        ;;
    "stop")
        stop_app
        ;;
    "restart")
        restart_app
        ;;
    "logs")
        show_logs "$@"
        ;;
    "status")
        show_status
        ;;
    "shell")
        access_shell "$@"
        ;;
    "backup")
        backup_db
        ;;
    "restore")
        restore_db "$@"
        ;;
    "cleanup")
        cleanup
        ;;
    "help"|"--help"|"-h"|"")
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac 