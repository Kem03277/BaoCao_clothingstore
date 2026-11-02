package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public record OrderResponse(
        Long id,
        String orderCode,
        String recipientName,
        String recipientPhone,
        String shippingAddress,
        BigDecimal subtotal,
        BigDecimal discountAmount,
        BigDecimal shippingFee,
        BigDecimal totalAmount,
        String status,
        String paymentMethod,
        String paymentStatus,
        String note,
        LocalDateTime createdAt,
        LocalDateTime updatedAt,
        Long userId,
        String userName,
        List<OrderItemResponse> items,
        String couponCode) {

    public OrderResponse(
            Long id,
            String orderCode,
            String recipientName,
            String recipientPhone,
            String shippingAddress,
            BigDecimal subtotal,
            BigDecimal discountAmount,
            BigDecimal shippingFee,
            BigDecimal totalAmount,
            String status,
            String paymentMethod,
            String paymentStatus,
            String note,
            LocalDateTime createdAt,
            LocalDateTime updatedAt,
            Long userId,
            String userName,
            List<OrderItemResponse> items) {
        this(id, orderCode, recipientName, recipientPhone, shippingAddress, subtotal, discountAmount,
                shippingFee, totalAmount, status, paymentMethod, paymentStatus, note, createdAt,
                updatedAt, userId, userName, items, null);
    }
}
