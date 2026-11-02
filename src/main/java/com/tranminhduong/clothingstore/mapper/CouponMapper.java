package com.tranminhduong.clothingstore.mapper;

import com.tranminhduong.clothingstore.dto.CouponRequest;
import com.tranminhduong.clothingstore.dto.CouponResponse;
import com.tranminhduong.clothingstore.entity.Coupon;
import org.springframework.stereotype.Component;

@Component
public class CouponMapper {

    public Coupon toEntity(CouponRequest request) {
        if (request == null) {
            return null;
        }
        Coupon coupon = new Coupon();
        coupon.setCode(request.code());
        coupon.setName(request.name());
        coupon.setDiscountType(request.discountType());
        coupon.setDiscountValue(request.discountValue());
        coupon.setApplyScope(request.applyScope());
        coupon.setMinOrderAmount(request.minOrderAmount());
        coupon.setMaxDiscount(request.maxDiscount());
        coupon.setStartAt(request.startAt());
        coupon.setEndAt(request.endAt());
        coupon.setStatus(request.status());
        return coupon;
    }

    public CouponResponse toResponse(Coupon coupon) {
        if (coupon == null) {
            return null;
        }
        return new CouponResponse(
                coupon.getId(),
                coupon.getCode(),
                coupon.getName(),
                isPercentage(coupon.getDiscountType()) ? "PERCENTAGE" : coupon.getDiscountType(),
                coupon.getDiscountValue(),
                coupon.getApplyScope(),
                coupon.getMinOrderAmount(),
                coupon.getMaxDiscount(),
                coupon.getStartAt(),
                coupon.getEndAt(),
                coupon.getStatus());
    }

    private boolean isPercentage(String discountType) {
        return "PERCENT".equalsIgnoreCase(discountType) || "PERCENTAGE".equalsIgnoreCase(discountType);
    }
}
