-- Procedure to get price on a specific date (for historical analysis)
CREATE PROCEDURE sp_get_price_on_date(
    IN p_product_id BIGINT,
    IN p_query_date DATE,
    OUT p_price DECIMAL(10,2),
    OUT p_price_type VARCHAR(20)
)
BEGIN
    SELECT price, price_type
    INTO p_price, p_price_type
    FROM product_price_history
    WHERE product_id = p_product_id
      AND effective_date <= p_query_date
      AND (end_date IS NULL OR end_date > p_query_date)
      AND is_active = TRUE
    ORDER BY effective_date DESC
    LIMIT 1;
END
