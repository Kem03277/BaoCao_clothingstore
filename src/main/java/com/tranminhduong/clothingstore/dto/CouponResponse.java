package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public record CouponResponse(
        Long id,
        String code,
        String name,
        String discountType,
        BigDecimal discountValue,
        String applyScope,
        BigDecimal minOrderAmount,
        BigDecimal maxDiscount,
        LocalDateTime startAt,
        LocalDateTime endAt,
        Boolean status) {
}
