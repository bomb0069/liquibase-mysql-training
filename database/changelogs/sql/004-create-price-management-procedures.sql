-- Create stored procedures for price management operations
-- These procedures provide a clean API for managing product prices

-- Procedure to set a new product price with effective date
CREATE PROCEDURE sp_set_product_price(
    IN p_product_id BIGINT,
    IN p_price DECIMAL(10,2),
    IN p_effective_date DATE,
    IN p_price_type VARCHAR(20),
    IN p_reason VARCHAR(255),
    IN p_created_by VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- End current active price if setting immediate price change
    IF p_effective_date <= CURDATE() THEN
        UPDATE product_price_history 
        SET end_date = CURDATE() - INTERVAL 1 DAY,
            updated_at = CURRENT_TIMESTAMP
        WHERE product_id = p_product_id 
          AND end_date IS NULL 
          AND effective_date <= CURDATE()
          AND is_active = TRUE;
    END IF;
    
    -- Insert new price record
    INSERT INTO product_price_history (
        product_id, price, effective_date, price_type, reason, created_by
    ) VALUES (
        p_product_id, p_price, p_effective_date, p_price_type, p_reason, p_created_by
    );
    
    COMMIT;
END

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
END //

-- Procedure to cancel a future price change
CREATE PROCEDURE sp_cancel_future_price(
    IN p_product_id BIGINT,
    IN p_effective_date DATE,
    IN p_cancelled_by VARCHAR(100)
)
BEGIN
    UPDATE product_price_history 
    SET is_active = FALSE,
        reason = CONCAT(COALESCE(reason, ''), ' [CANCELLED by ', p_cancelled_by, ']'),
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = p_product_id 
      AND effective_date = p_effective_date
      AND effective_date > CURDATE()
      AND is_active = TRUE;
END //

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
END //

DELIMITER ;
