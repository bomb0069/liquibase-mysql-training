-- Rollback: Drop price management stored procedures
DROP PROCEDURE IF EXISTS sp_get_price_on_date;
DROP PROCEDURE IF EXISTS sp_cancel_future_price;
DROP PROCEDURE IF EXISTS sp_get_current_price;
DROP PROCEDURE IF EXISTS sp_set_product_price;
