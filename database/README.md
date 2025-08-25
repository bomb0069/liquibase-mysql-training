# Database Schema Migration with Liquibase

This directory contains Liquibase database migration files for the shopping cart application.

## Structure

```
database/
├── changelog-master.xml          # Main changelog file that includes all migrations
├── liquibase.properties         # Liquibase configuration properties
└── changelogs/
    └── 001-create-customer-table.xml  # Customer table and related migrations
```

## Customer Schema

The migration creates the following tables:

### customers
- `id` (BIGINT, AUTO_INCREMENT, PRIMARY KEY)
- `email` (VARCHAR(255), UNIQUE, NOT NULL)
- `first_name` (VARCHAR(100), NOT NULL)
- `last_name` (VARCHAR(100), NOT NULL)
- `phone` (VARCHAR(20), NULLABLE)
- `date_of_birth` (DATE, NULLABLE)
- `status` (VARCHAR(20), DEFAULT 'ACTIVE')
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### customer_addresses
- `id` (BIGINT, AUTO_INCREMENT, PRIMARY KEY)
- `customer_id` (BIGINT, FOREIGN KEY to customers.id)
- `address_type` (VARCHAR(20)) - e.g., 'SHIPPING', 'BILLING'
- `street_address` (VARCHAR(255))
- `city` (VARCHAR(100))
- `state` (VARCHAR(100))
- `postal_code` (VARCHAR(20))
- `country` (VARCHAR(100))
- `is_default` (BOOLEAN, DEFAULT false)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

## Running Migrations

### Using Docker Compose

The Liquibase service uses a custom Docker image with MySQL driver pre-installed and will run automatically when you start the services:

```bash
# Build custom image (first time only)
./build.sh build

# Start services with automatic migration
docker-compose up -d
```

The Liquibase container will:
1. Wait for the MySQL database to be healthy
2. Run all pending migrations using the pre-installed MySQL driver
3. Exit after successful completion

### Manual Liquibase Commands

If you want to run Liquibase commands manually, you can use the following docker commands:

#### Update Database (Run Migrations)
```bash
docker run --rm --network mysql_default \
  -v $(pwd)/database:/liquibase/changelog \
  mysql-liquibase-custom \
  --url=jdbc:mysql://db:3306/store \
  --username=user \
  --password=password \
  --changeLogFile=changelog-master.xml \
  update
```

#### Check Migration Status
```bash
docker run --rm --network mysql_default \
  -v $(pwd)/database:/liquibase/changelog \
  mysql-liquibase-custom \
  --url=jdbc:mysql://db:3306/store \
  --username=user \
  --password=password \
  --changeLogFile=changelog-master.xml \
  status
```

#### Generate SQL for Review (without executing)
```bash
docker run --rm --network mysql_default \
  -v $(pwd)/database:/liquibase/changelog \
  mysql-liquibase-custom \
  --url=jdbc:mysql://db:3306/store \
  --username=user \
  --password=password \
  --changeLogFile=changelog-master.xml \
  updateSQL
```

#### Rollback Last Migration
```bash
docker run --rm --network mysql_default \
  -v $(pwd)/database:/liquibase/changelog \
  mysql-liquibase-custom \
  --url=jdbc:mysql://db:3306/store \
  --username=user \
  --password=password \
  --changeLogFile=changelog-master.xml \
  rollbackCount 1
```

## Sample Data

The migration includes sample customer data:

1. **John Doe** (john.doe@example.com)
   - Phone: +1-555-0123
   - Address: 123 Main St, New York, NY 10001

2. **Jane Smith** (jane.smith@example.com)
   - Phone: +1-555-0456
   - Address: 456 Oak Ave, Los Angeles, CA 90210

3. **Mike Johnson** (mike.johnson@example.com)
   - Phone: +1-555-0789

## Adding New Migrations

1. Create a new XML file in the `changelogs/` directory
2. Use a sequential naming convention: `002-add-new-feature.xml`
3. Add the new file to `changelog-master.xml`
4. Run the migration using docker-compose or manual commands

## Best Practices

- Always include rollback statements in your changesets
- Use descriptive comments for each changeset
- Test migrations in a development environment first
- Use meaningful changeset IDs and author names
- Keep changesets atomic and focused on single changes
