-- Rollback: Clear migrated price data
DELETE FROM product_price_history 
WHERE reason = 'Migrated from existing product_price column' 
  AND created_by = 'system_migration';
