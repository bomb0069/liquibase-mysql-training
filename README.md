# Liquibase MySQL Training

This project demonstrates database schema migration using Liquibase with MySQL in a Docker environment.

## Project Structure

```
├── Dockerfile                 # Custom Liquibase image with MySQL driver
├── docker-compose.yml          # Docker services configuration
├── build.sh                   # Custom image build script
├── migrate.sh                 # Migration helper script
├── .dockerignore              # Docker build context exclusions
├── tearup/
│   └── init.sql               # Initial database setup
├── database/                  # Liquibase migration files
│   ├── changelog-master.xml   # Main changelog
│   ├── liquibase.properties   # Liquibase configuration
│   ├── README.md             # Database migration documentation
│   └── changelogs/
│       └── 001-create-customer-table.xml  # Customer table migrations
└── README.md                  # This file
```

## Services

- **db**: MySQL 8.3.0 database server
- **liquibase**: Custom Liquibase image with MySQL driver pre-installed
- **admin**: Adminer web interface for database management

## Quick Start

1. **Build the custom Liquibase image (first time only):**
   ```bash
   ./build.sh build
   ```

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```

3. **Check migration status:**
   ```bash
   ./migrate.sh status
   ```

4. **Access database via Adminer:**
   - URL: http://localhost:8080
   - Server: db
   - Username: user
   - Password: password
   - Database: store

## Database Schema

The project includes migrations for a shopping cart application with:

- **customers**: Customer information table
- **customer_addresses**: Customer shipping/billing addresses
- **users**: Existing users table (from init.sql)
- **products**: Existing products table (from init.sql)

## Migration Management

### Using the Helper Script

The `migrate.sh` script provides convenient commands:

```bash
./migrate.sh update    # Apply all pending migrations
./migrate.sh status    # Check migration status
./migrate.sh sql       # Generate SQL (dry run)
./migrate.sh rollback 1  # Rollback last migration
./migrate.sh validate  # Validate changelog
./migrate.sh history   # Show migration history
```

### Custom Image Management

The `build.sh` script manages the custom Liquibase image:

```bash
./build.sh build      # Build the custom image
./build.sh rebuild    # Rebuild without cache
./build.sh info       # Show image details
./build.sh clean      # Remove the image
```

### Manual Docker Commands

See the `database/README.md` file for detailed manual commands.

## Adding New Migrations

1. Create a new XML file in `database/changelogs/`
2. Follow the naming convention: `002-description.xml`
3. Add the new file to `database/changelog-master.xml`
4. Run migrations using `./migrate.sh update`

## Development Workflow

1. Make schema changes using Liquibase changesets
2. Test migrations in development environment
3. Review generated SQL before applying to production
4. Use rollback capabilities for safe deployments

## Troubleshooting

- Ensure Docker is running and containers are healthy
- Check network connectivity between containers
- Review Liquibase logs for detailed error messages
- Use `./migrate.sh validate` to check changelog syntax
