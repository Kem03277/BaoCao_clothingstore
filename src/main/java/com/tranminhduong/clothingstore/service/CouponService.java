package com.tranminhduong.clothingstore.service;

import com.tranminhduong.clothingstore.dto.CouponApplyResponse;
import com.tranminhduong.clothingstore.dto.CouponValidationRequest;
import com.tranminhduong.clothingstore.dto.CouponValidationResponse;
import com.tranminhduong.clothingstore.entity.Coupon;

import java.util.List;

public interface CouponService {
    List<Coupon> getAllCoupons();
    List<Coupon> getDeletedCoupons();
    Coupon getCouponById(Long id);
    Coupon createCoupon(Coupon coupon);
    Coupon updateCoupon(Long id, Coupon coupon);
    Coupon updateStatus(Long id, Boolean status);
    CouponValidationResponse validateForCart(CouponValidationRequest request);
    void deleteCoupon(Long id);
    void restoreDeletedCoupon(Long id);
    void restoreAllDeletedCoupons();
    void deleteCouponPermanently(Long id);
    void addCategory(Long couponId, Long categoryId);
    void removeCategory(Long couponId, Long categoryId);
    List<CouponApplyResponse> getCategories(Long couponId);
    void addProduct(Long couponId, Long productId);
    void removeProduct(Long couponId, Long productId);
    List<CouponApplyResponse> getProducts(Long couponId);
}
