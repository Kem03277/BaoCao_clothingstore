SET @gateway_transaction_no_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'payments'
      AND COLUMN_NAME = 'gateway_transaction_no'
);

SET @add_gateway_transaction_no = IF(
    @gateway_transaction_no_exists = 0,
    'ALTER TABLE payments ADD COLUMN gateway_transaction_no VARCHAR(100) NULL',
    'SELECT ''payments.gateway_transaction_no already exists'''
);

PREPARE add_gateway_transaction_no_statement FROM @add_gateway_transaction_no;
EXECUTE add_gateway_transaction_no_statement;
DEALLOCATE PREPARE add_gateway_transaction_no_statement;
