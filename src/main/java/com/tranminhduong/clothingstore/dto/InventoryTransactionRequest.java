package com.tranminhduong.clothingstore.dto;

public record InventoryTransactionRequest(Integer quantity, Integer quantityChange, String reason, Long createdById) {
}