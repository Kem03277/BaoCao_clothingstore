package com.tranminhduong.clothingstore.dto;

public record InventoryRequest(Long productId, Integer quantity, Integer lowStockThreshold) {
}