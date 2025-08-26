-- Create product price history table to track pricing changes with effective dates
-- This allows retailers to plan price changes in advance and maintain historical pricing data

CREATE TABLE product_price_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id BIGINT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    effective_date DATE NOT NULL,
    end_date DATE NULL,
    currency_code VARCHAR(3) DEFAULT 'USD',
    price_type ENUM('REGULAR', 'SALE', 'CLEARANCE', 'PROMOTION') DEFAULT 'REGULAR',
    reason VARCHAR(255) NULL COMMENT 'Reason for price change',
    created_by VARCHAR(100) NULL COMMENT 'User who created this price entry',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_product_effective_date (product_id, effective_date),
    INDEX idx_effective_date (effective_date),
    INDEX idx_price_type (price_type),
    INDEX idx_is_active (is_active),
    
    -- Foreign key constraint
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    
    -- Unique constraint to prevent overlapping price periods for the same product
    UNIQUE KEY uk_product_effective_date (product_id, effective_date)
) CHARACTER SET utf8 COLLATE utf8_general_ci 
COMMENT 'Historical pricing data with effective dates for future price planning';
