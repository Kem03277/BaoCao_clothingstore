package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.OrderItemResponse;
import com.tranminhduong.clothingstore.dto.OrderResponse;
import com.tranminhduong.clothingstore.entity.Order;
import com.tranminhduong.clothingstore.entity.OrderItem;
import com.tranminhduong.clothingstore.entity.Payment;
import com.tranminhduong.clothingstore.entity.Product;
import com.tranminhduong.clothingstore.entity.ProductImage;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class OrderMapper {

    public OrderResponse toResponse(Order order) {
        if (order == null) {
            return null;
        }
        List<OrderItemResponse> items = order.getOrderItems() == null
                ? List.of()
                : order.getOrderItems().stream().map(this::toResponse).toList();
        Payment payment = order.getPayments() == null
                ? null
                : order.getPayments().stream().findFirst().orElse(null);
        String couponCode = null;
        if (order.getCoupon() != null) {
            try {
                couponCode = order.getCoupon().getCode();
            } catch (Exception ignored) {
                // Ignore lazy initialization if session is closed
            }
        }
        return new OrderResponse(
                order.getId(),
                order.getOrderCode(),
                order.getRecipientName(),
                order.getRecipientPhone(),
                order.getShippingAddress(),
                order.getSubtotal(),
                order.getDiscountAmount(),
                order.getShippingFee(),
                order.getTotalAmount(),
                order.getStatus(),
                payment == null ? null : payment.getMethod(),
                payment == null ? null : payment.getStatus(),
                order.getNote(),
                order.getCreatedAt(),
                order.getUpdatedAt(),
                order.getUser() == null ? null : order.getUser().getId(),
                order.getUser() == null ? null : order.getUser().getFullName(),
                items,
                couponCode);
    }

    private OrderItemResponse toResponse(OrderItem item) {
        Product product = item.getProduct();
        String imageUrl = null;
        if (product != null) {
            try {
                List<ProductImage> images = product.getImages();
                if (images != null && !images.isEmpty()) {
                    imageUrl = images.stream()
                            .filter(img -> Boolean.TRUE.equals(img.getPrimary()))
                            .map(ProductImage::getImageUrl)
                            .findFirst()
                            .orElseGet(() -> images.get(0).getImageUrl());
                }
            } catch (Exception ignored) {
                // Ignore lazy initialization if session is closed
            }
        }
        return new OrderItemResponse(
                item.getId(),
                item.getProductName(),
                item.getSku(),
                item.getSizeName(),
                item.getQuantity(),
                item.getUnitPrice(),
                item.getLineTotal(),
                product == null ? null : product.getId(),
                imageUrl);
    }
}
