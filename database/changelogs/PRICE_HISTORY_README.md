# Product Price History System

This changeset demonstrates how to use YAML changesets with external SQL files to implement a comprehensive product price history system with effective dates.

## Architecture Overview

This implementation separates concerns by:
- **YAML Changesets**: Define metadata, dependencies, and rollback strategies
- **SQL Files**: Contain the actual database logic, organized by functionality
- **Rollback Files**: Provide clean rollback procedures for each changeset

## Features Implemented

### 1. Historical Price Tracking
- Track all price changes with effective dates
- Support for future price scheduling
- Multiple price types (REGULAR, SALE, CLEARANCE, PROMOTION)
- Currency support and change reasons

### 2. Business Intelligence Views
- `v_current_product_prices`: Current effective prices for all products
- `v_upcoming_price_changes`: Scheduled future price changes
- `v_product_price_history`: Complete price history with analytics

### 3. Price Management API
- `sp_set_product_price()`: Set new prices with effective dates
- `sp_get_current_price()`: Get current price for a product
- `sp_cancel_future_price()`: Cancel scheduled price changes
- `sp_get_price_on_date()`: Historical price lookup

### 4. Data Integrity & Audit
- Triggers to maintain price consistency
- Audit trail for all price changes
- Prevention of overlapping price periods
- Automatic cleanup of old prices

## File Structure

```
changelogs/
├── 003-create-product-price-history.yaml     # Main changeset definition
└── sql/
    ├── 001-create-product-price-history-table.sql
    ├── 002-migrate-current-product-prices.sql
    ├── 003-create-price-history-views.sql
    ├── 004-create-price-management-procedures.sql
    ├── 005-insert-sample-price-schedules.sql
    ├── 006-create-price-change-triggers.sql
    └── rollback/
        ├── 001-drop-product-price-history-table.sql
        ├── 002-clear-migrated-prices.sql
        ├── 003-drop-price-history-views.sql
        ├── 004-drop-price-management-procedures.sql
        ├── 005-clear-sample-price-schedules.sql
        └── 006-drop-price-change-triggers.sql
```

## Benefits of This Approach

### 1. **Separation of Concerns**
- YAML handles changeset metadata and orchestration
- SQL files contain business logic and can be version controlled separately
- Easier to review and maintain complex database changes

### 2. **Modularity**
- Each SQL file handles a specific aspect of the system
- Can be developed and tested independently
- Easier to rollback specific components

### 3. **Reusability**
- SQL files can be reused across different environments
- Procedures and views can be shared with development teams
- Clear API for price management operations

### 4. **Testing & Development**
- SQL files can be tested independently before integration
- Easier to debug specific components
- Better collaboration between database and application developers

## Usage Examples

### Set a Future Price
```sql
CALL sp_set_product_price(1, 149.95, '2025-12-01', 'REGULAR', 'Holiday season pricing', 'pricing_manager');
```

### Get Current Price
```sql
CALL sp_get_current_price(1, @price, @type, @effective_date);
SELECT @price, @type, @effective_date;
```

### View Upcoming Changes
```sql
SELECT * FROM v_upcoming_price_changes WHERE days_until_change <= 30;
```

### Cancel a Future Price
```sql
CALL sp_cancel_future_price(1, '2025-12-01', 'manager');
```

## Business Benefits

1. **Advanced Price Planning**: Set prices months in advance for seasonal campaigns
2. **Price History Analysis**: Track pricing trends and effectiveness
3. **Automated Price Management**: Triggers handle complex business rules
4. **Audit Compliance**: Complete trail of all price changes
5. **Multi-currency Support**: Ready for international expansion
6. **Flexible Pricing Types**: Support for sales, clearances, and promotions

This example showcases best practices for complex database migrations using Liquibase with external SQL files, providing both technical excellence and business value.
