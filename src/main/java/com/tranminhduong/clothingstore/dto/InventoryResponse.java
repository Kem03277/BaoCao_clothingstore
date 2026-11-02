package com.tranminhduong.clothingstore.dto;

import java.time.LocalDateTime;

public record InventoryResponse(Long productId, Integer quantity, Integer lowStockThreshold, LocalDateTime updatedAt) {
}