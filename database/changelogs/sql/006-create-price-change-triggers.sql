-- Create audit log table for price changes first
CREATE TABLE price_audit_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    price_history_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    old_price DECIMAL(10,2),
    new_price DECIMAL(10,2),
    old_is_active BOOLEAN,
    new_is_active BOOLEAN,
    change_type ENUM('PRICE_CHANGE', 'STATUS_CHANGE', 'OTHER') NOT NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(255),
    
    INDEX idx_product_changed_at (product_id, changed_at),
    INDEX idx_change_type (change_type),
    INDEX idx_changed_at (changed_at),
    
    FOREIGN KEY (price_history_id) REFERENCES product_price_history(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
) CHARACTER SET utf8 COLLATE utf8_general_ci 
COMMENT 'Audit trail for all price history changes';
