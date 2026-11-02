-- Refuse to remove legacy size data or unverified foreign-key relationships.
DELIMITER $$

DROP PROCEDURE IF EXISTS assert_legacy_sizes_are_unused$$

CREATE PROCEDURE assert_legacy_sizes_are_unused()
BEGIN
    DECLARE size_rows BIGINT DEFAULT 0;
    DECLARE product_size_refs BIGINT DEFAULT 0;
    DECLARE size_fk_count BIGINT DEFAULT 0;

    SELECT COUNT(*) INTO size_rows
    FROM sizes;

    SELECT COUNT(*) INTO product_size_refs
    FROM products
    WHERE size_id IS NOT NULL;

    SELECT COUNT(*) INTO size_fk_count
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_SCHEMA = DATABASE()
      AND REFERENCED_TABLE_NAME = 'sizes';

    IF size_rows > 0 OR product_size_refs > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Migration stopped: sizes or products.size_id contain data; migrate size data before removal.';
    END IF;

    IF size_fk_count <> 1
       OR NOT EXISTS (
            SELECT 1
            FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE()
              AND TABLE_NAME = 'products'
              AND COLUMN_NAME = 'size_id'
              AND CONSTRAINT_NAME = 'FKjtp03phh84ohguj0rhvlk81g7'
              AND REFERENCED_TABLE_NAME = 'sizes'
              AND REFERENCED_COLUMN_NAME = 'size_id'
       ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Migration stopped: foreign-key schema differs from the inspected Clothing Store database.';
    END IF;
END$$

CALL assert_legacy_sizes_are_unused()$$
DROP PROCEDURE assert_legacy_sizes_are_unused$$

DELIMITER ;

ALTER TABLE products
    DROP FOREIGN KEY FKjtp03phh84ohguj0rhvlk81g7,
    DROP COLUMN size_id;

DROP TABLE sizes;
