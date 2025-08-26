-- Insert sample future price schedules to demonstrate the system
-- This shows how retailers can plan price changes in advance

-- Example 1: Planned price increases for popular products (simulating inflation adjustment)
INSERT INTO product_price_history (
    product_id, price, effective_date, price_type, reason, created_by
) VALUES 
-- Balance Training Bicycle - price increase in 30 days
(1, 129.95, DATE_ADD(CURDATE(), INTERVAL 30 DAY), 'REGULAR', 'Annual price adjustment for inflation', 'pricing_manager'),

-- 43 Piece dinner Set - sale price next week, then back to regular
(2, 9.95, DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'SALE', 'Weekly flash sale promotion', 'marketing_team'),
(2, 14.95, DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'REGULAR', 'Return to regular pricing after sale', 'pricing_manager'),

-- Horses and Unicorns Set - clearance sale in 2 weeks
(3, 19.95, DATE_ADD(CURDATE(), INTERVAL 14 DAY), 'CLEARANCE', 'End of season clearance', 'inventory_manager'),

-- Hoppity Ball - promotional pricing for summer season
(4, 24.95, DATE_ADD(CURDATE(), INTERVAL 21 DAY), 'PROMOTION', 'Summer sports promotion', 'marketing_team'),
(4, 32.95, DATE_ADD(CURDATE(), INTERVAL 90 DAY), 'REGULAR', 'End of summer promotion', 'pricing_manager'),

-- Sleeping Queens Board Game - holiday pricing strategy
(5, 10.95, DATE_ADD(CURDATE(), INTERVAL 45 DAY), 'SALE', 'Pre-holiday sale pricing', 'marketing_team'),
(5, 15.95, DATE_ADD(CURDATE(), INTERVAL 75 DAY), 'REGULAR', 'Holiday season regular price', 'pricing_manager'),

-- Princess Palace - gradual price increase strategy
(6, 27.95, DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'REGULAR', 'Supply cost increase adjustment', 'pricing_manager'),

-- Best Friends Forever Magnetic Dress Up - seasonal promotion
(7, 19.95, DATE_ADD(CURDATE(), INTERVAL 28 DAY), 'PROMOTION', 'Back-to-school promotion', 'marketing_team'),

-- Lego products - coordinated price adjustments
(8, 22.95, DATE_ADD(CURDATE(), INTERVAL 35 DAY), 'REGULAR', 'Manufacturer suggested retail price update', 'pricing_manager'),
(20, 44.95, DATE_ADD(CURDATE(), INTERVAL 35 DAY), 'REGULAR', 'Manufacturer suggested retail price update', 'pricing_manager'),

-- Kettrike Tricycle - premium product price positioning
(9, 269.95, DATE_ADD(CURDATE(), INTERVAL 40 DAY), 'REGULAR', 'Premium positioning strategy', 'pricing_manager');

-- Example of price scheduling with end dates (limited time offers)
INSERT INTO product_price_history (
    product_id, price, effective_date, end_date, price_type, reason, created_by
) VALUES 
-- Limited time flash sale for Earth DVD Game
(11, 24.99, DATE_ADD(CURDATE(), INTERVAL 10 DAY), DATE_ADD(CURDATE(), INTERVAL 17 DAY), 'SALE', '7-day flash sale event', 'marketing_team'),

-- Weekend promotion for Twilight Board Game
(12, 19.95, DATE_ADD(CURDATE(), INTERVAL 14 DAY), DATE_ADD(CURDATE(), INTERVAL 16 DAY), 'PROMOTION', 'Weekend special promotion', 'marketing_team'),

-- Black Friday early bird pricing for Settlers of Catan
(13, 34.95, DATE_ADD(CURDATE(), INTERVAL 50 DAY), DATE_ADD(CURDATE(), INTERVAL 57 DAY), 'SALE', 'Black Friday early bird special', 'marketing_team');
