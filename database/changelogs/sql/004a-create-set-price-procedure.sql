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
