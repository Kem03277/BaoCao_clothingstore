package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.util.List;

public record UserOrderRequest(
        Long addressId,
        String couponCode,
        String note,
        List<OrderItemRequest> items,
        String paymentMethod
) {
    public UserOrderRequest(Long addressId, String couponCode, String note, List<OrderItemRequest> items) {
        this(addressId, couponCode, note, items, "COD");
    }

    public record OrderItemRequest(
            Long productId,
            String size,
            int quantity,
            BigDecimal price
    ) {}
}
