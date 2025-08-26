-- Create views for easier price querying and current price lookup
-- These views simplify common pricing queries for applications

-- View to get current effective price for each product
CREATE VIEW v_current_product_prices AS
SELECT 
    p.id AS product_id,
    p.product_name,
    p.product_brand,
    p.stock,
    ph.price AS current_price,
    ph.currency_code,
    ph.price_type,
    ph.effective_date,
    ph.reason AS price_change_reason,
    ph.created_at AS price_set_at
FROM products p
INNER JOIN product_price_history ph ON p.id = ph.product_id
WHERE ph.effective_date <= CURDATE()
  AND (ph.end_date IS NULL OR ph.end_date > CURDATE())
  AND ph.is_active = TRUE
ORDER BY p.id, ph.effective_date DESC;

-- View to get upcoming price changes
CREATE VIEW v_upcoming_price_changes AS
SELECT 
    p.id AS product_id,
    p.product_name,
    p.product_brand,
    current_ph.price AS current_price,
    future_ph.price AS upcoming_price,
    future_ph.effective_date AS price_change_date,
    future_ph.price_type AS upcoming_price_type,
    future_ph.reason AS change_reason,
    DATEDIFF(future_ph.effective_date, CURDATE()) AS days_until_change,
    ((future_ph.price - current_ph.price) / current_ph.price) * 100 AS price_change_percent
FROM products p
INNER JOIN product_price_history current_ph ON p.id = current_ph.product_id
INNER JOIN product_price_history future_ph ON p.id = future_ph.product_id
WHERE current_ph.effective_date <= CURDATE()
  AND (current_ph.end_date IS NULL OR current_ph.end_date > CURDATE())
  AND current_ph.is_active = TRUE
  AND future_ph.effective_date > CURDATE()
  AND future_ph.is_active = TRUE
ORDER BY future_ph.effective_date ASC, p.product_name;

-- View to get complete price history for analysis
CREATE VIEW v_product_price_history AS
SELECT 
    p.id AS product_id,
    p.product_name,
    p.product_brand,
    ph.price,
    ph.effective_date,
    ph.end_date,
    ph.currency_code,
    ph.price_type,
    ph.reason,
    ph.created_by,
    ph.created_at,
    LAG(ph.price) OVER (PARTITION BY p.id ORDER BY ph.effective_date) AS previous_price,
    CASE 
        WHEN LAG(ph.price) OVER (PARTITION BY p.id ORDER BY ph.effective_date) IS NOT NULL 
        THEN ((ph.price - LAG(ph.price) OVER (PARTITION BY p.id ORDER BY ph.effective_date)) / LAG(ph.price) OVER (PARTITION BY p.id ORDER BY ph.effective_date)) * 100 
        ELSE NULL 
    END AS price_change_percent
FROM products p
INNER JOIN product_price_history ph ON p.id = ph.product_id
WHERE ph.is_active = TRUE
ORDER BY p.id, ph.effective_date;
