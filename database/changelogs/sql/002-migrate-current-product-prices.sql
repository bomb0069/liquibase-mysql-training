-- Migrate existing product prices to the new price history system
-- This preserves current pricing while enabling the new historical tracking system

INSERT INTO product_price_history (
    product_id, 
    price, 
    effective_date, 
    end_date,
    currency_code,
    price_type, 
    reason, 
    created_by,
    is_active
)
SELECT 
    id AS product_id,
    product_price AS price,
    '2025-01-01' AS effective_date,  -- Set a baseline effective date
    NULL AS end_date,                -- Open-ended, current price
    'USD' AS currency_code,
    'REGULAR' AS price_type,
    'Migrated from existing product_price column' AS reason,
    'system_migration' AS created_by,
    TRUE AS is_active
FROM products 
WHERE product_price IS NOT NULL 
  AND product_price > 0
ORDER BY id;
