-- Migration: Add gender column to products for independent filtering (MALE, FEMALE, UNISEX)
ALTER TABLE products
    ADD COLUMN IF NOT EXISTS gender VARCHAR(20) DEFAULT 'UNISEX';
