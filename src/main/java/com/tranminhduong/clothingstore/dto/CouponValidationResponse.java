package com.tranminhduong.clothingstore.dto;

import java.math.BigDecimal;
import java.util.List;

public record CouponValidationResponse(
        CouponResponse coupon,
        BigDecimal eligibleSubtotal,
        BigDecimal discountAmount,
        List<Long> eligibleProductIds) {
}
