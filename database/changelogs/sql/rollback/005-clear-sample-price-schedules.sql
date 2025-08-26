-- Rollback: Clear sample price schedules
DELETE FROM product_price_history 
WHERE created_by IN ('pricing_manager', 'marketing_team', 'inventory_manager') 
  AND effective_date > '2025-01-01';
