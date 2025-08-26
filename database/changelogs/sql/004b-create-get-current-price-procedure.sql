-- Procedure to get current price for a product
CREATE PROCEDURE sp_get_current_price(
    IN p_product_id BIGINT,
    OUT p_current_price DECIMAL(10,2),
    OUT p_price_type VARCHAR(20),
    OUT p_effective_date DATE
)
BEGIN
    SELECT price, price_type, effective_date
    INTO p_current_price, p_price_type, p_effective_date
    FROM product_price_history
    WHERE product_id = p_product_id
      AND effective_date <= CURDATE()
      AND (end_date IS NULL OR end_date > CURDATE())
      AND is_active = TRUE
    ORDER BY effective_date DESC
    LIMIT 1;
END
