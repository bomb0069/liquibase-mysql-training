-- Rollback: Drop audit table (triggers not created due to Liquibase compatibility)
DROP TABLE IF EXISTS price_audit_log;
