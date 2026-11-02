package com.tranminhduong.clothingstore.dto;

import java.time.LocalDateTime;

public record InventoryTransactionResponse(Long id, Long productId, Integer quantityChange,
        Integer quantityAfter, String reason, LocalDateTime createdAt, Long createdById) {
}