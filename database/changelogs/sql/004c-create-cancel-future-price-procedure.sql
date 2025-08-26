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
END
