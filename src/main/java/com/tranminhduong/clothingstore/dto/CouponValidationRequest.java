package com.tranminhduong.clothingstore.dto;

import java.util.List;

public record CouponValidationRequest(String code, List<CouponCartItem> items) {
}
