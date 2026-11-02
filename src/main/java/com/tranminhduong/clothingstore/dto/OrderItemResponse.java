package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;

public record OrderItemResponse(
        Long id,
        String productName,
        String sku,
        String sizeName,
        Integer quantity,
        BigDecimal unitPrice,
        BigDecimal lineTotal,
        Long productId,
        String imageUrl) {

    public OrderItemResponse(
            Long id,
            String productName,
            String sku,
            String sizeName,
            Integer quantity,
            BigDecimal unitPrice,
            BigDecimal lineTotal,
            Long productId) {
        this(id, productName, sku, sizeName, quantity, unitPrice, lineTotal, productId, null);
    }
}
